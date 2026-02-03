from flask import Flask, request, jsonify, render_template_string, redirect
import redis
import hashlib
import os

app = Flask(__name__)

# Connect to Redis
redis_host = os.getenv('REDIS_HOST', 'localhost')
redis_port = int(os.getenv('REDIS_PORT', 6379))
r = redis.Redis(host=redis_host, port=redis_port, decode_responses=True)

# Simple HTML template
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>URL Shortener</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 50px auto; padding: 20px; }
        h1 { color: #333; }
        input[type="text"] { width: 70%; padding: 10px; font-size: 16px; }
        button { padding: 10px 20px; font-size: 16px; background: #007bff; color: white; border: none; cursor: pointer; }
        button:hover { background: #0056b3; }
        .result { margin-top: 20px; padding: 15px; background: #f0f0f0; border-radius: 5px; }
        .stats { margin-top: 30px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #007bff; color: white; }
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
    <h1>🔗 URL Shortener</h1>
    <p>Shorten your long URLs into easy-to-share links!</p>
    
    <div>
        <input type="text" id="longUrl" placeholder="Enter your long URL here...">
        <button onclick="shortenUrl()">Shorten URL</button>
    </div>
    
    <div id="result" class="result" style="display:none;"></div>
    
    <div class="stats">
        <h2>Statistics</h2>
        <p>Total URLs shortened: <strong id="totalUrls">0</strong></p>
        <button onclick="loadStats()">Refresh Stats</button>
    </div>

    <script>
        function shortenUrl() {
            const longUrl = document.getElementById('longUrl').value;
            if (!longUrl) {
                alert('Please enter a URL');
                return;
            }

            fetch('/api/shorten', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ url: longUrl })
            })
            .then(response => response.json())
            .then(data => {
                const resultDiv = document.getElementById('result');
                if (data.short_url) {
                    resultDiv.innerHTML = `
                        <p class="success">✓ URL shortened successfully!</p>
                        <p><strong>Original:</strong> ${data.original_url}</p>
                        <p><strong>Shortened:</strong> <a href="${data.short_url}" target="_blank">${data.short_url}</a></p>
                        <p><strong>Short Code:</strong> ${data.code}</p>
                    `;
                    resultDiv.style.display = 'block';
                    loadStats();
                } else {
                    resultDiv.innerHTML = `<p class="error">Error: ${data.error}</p>`;
                    resultDiv.style.display = 'block';
                }
            })
            .catch(error => {
                document.getElementById('result').innerHTML = `<p class="error">Error: ${error}</p>`;
            });
        }

        function loadStats() {
            fetch('/api/stats')
            .then(response => response.json())
            .then(data => {
                document.getElementById('totalUrls').textContent = data.total_urls;
            });
        }

        // Load stats on page load
        loadStats();
    </script>
</body>
</html>
"""

def generate_short_code(url):
    """Generate a short code from URL using hash"""
    hash_object = hashlib.md5(url.encode())
    return hash_object.hexdigest()[:6]

@app.route('/')
def index():
    return render_template_string(HTML_TEMPLATE)

@app.route('/api/shorten', methods=['POST'])
def shorten_url():
    """Shorten a URL"""
    data = request.get_json()
    original_url = data.get('url', '')
    
    if not original_url:
        return jsonify({'error': 'URL is required'}), 400
    
    # Generate short code
    short_code = generate_short_code(original_url)
    
    # Store in Redis
    r.set(f'url:{short_code}', original_url)
    r.incr('stats:total')
    
    # Build short URL
    base_url = request.host_url.rstrip('/')
    short_url = f"{base_url}/{short_code}"
    
    return jsonify({
        'original_url': original_url,
        'short_url': short_url,
        'code': short_code
    })

@app.route('/api/stats')
def stats():
    """Get statistics"""
    total = r.get('stats:total') or 0
    return jsonify({
        'total_urls': int(total)
    })

@app.route('/<short_code>')
def redirect_to_url(short_code):
    """Redirect to original URL"""
    original_url = r.get(f'url:{short_code}')
    
    if original_url:
        return redirect(original_url)
    else:
        return jsonify({'error': 'URL not found'}), 404

@app.route('/health')
def health():
    """Health check endpoint"""
    try:
        r.ping()
        return jsonify({'status': 'healthy', 'redis': 'connected'}), 200
    except Exception as e:
        return jsonify({'status': 'unhealthy', 'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
