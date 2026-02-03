# URL Shortener

Production-ready URL shortener microservice built with Flask and Redis, designed for Kubernetes deployment.

## Architecture

```
┌─────────────────────────────────────┐
│      Kubernetes Cluster             │
│                                     │
│  ┌────────────┐   ┌─────────────┐  │
│  │ Flask App  │───│   Redis     │  │
│  │ (Replicas) │   │ (Database)  │  │
│  └──────┬─────┘   └─────────────┘  │
│         │                           │
│    ┌────▼─────┐                     │
│    │ Service  │                     │
│    │ NodePort │                     │
│    │  :30080  │                     │
│    └──────────┘                     │
└─────────────────────────────────────┘
```

## Features

- RESTful API for URL shortening
- Persistent storage with Redis
- Kubernetes-native deployment
- Health check endpoints
- Horizontal scaling support
- Web UI for easy interaction

## Quick Deploy

```bash
cd url-shortener
./deploy.sh
```

## Manual Deployment

### Build Container Image

```bash
docker build -t url-shortener:v1 .
```

### Deploy to Kubernetes

```bash
# Deploy Redis
kubectl apply -f k8s/redis.yaml

# Deploy Application
kubectl apply -f k8s/app.yaml

# Verify deployment
kubectl get pods
kubectl get svc
```

## API Endpoints

### Shorten URL

**POST** `/shorten`

```bash
curl -X POST http://<IP>:30080/shorten \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com/very/long/url"}'
```

Response:
```json
{
  "short_url": "http://<IP>:30080/abc123",
  "short_code": "abc123"
}
```

### Redirect to Original URL

**GET** `/<short_code>`

```bash
curl http://<IP>:30080/abc123
```

### Get Statistics

**GET** `/stats`

```bash
curl http://<IP>:30080/stats
```

Response:
```json
{
  "total_urls": 42
}
```

## Configuration

### Environment Variables

- `REDIS_HOST`: Redis server hostname (default: `localhost`)
- `REDIS_PORT`: Redis server port (default: `6379`)

### Kubernetes Configuration

Edit `k8s/app.yaml` to customize:
- Replica count
- Resource limits
- Service type
- NodePort value

## Development

### Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Run Redis
docker run -d -p 6379:6379 redis:7-alpine

# Set environment variables
export REDIS_HOST=localhost
export REDIS_PORT=6379

# Run application
python app.py
```

Access at: `http://localhost:5000`

### Testing

```bash
# Test URL shortening
curl -X POST http://localhost:5000/shorten \
  -H "Content-Type: application/json" \
  -d '{"url": "https://github.com"}'

# Test redirect
curl -L http://localhost:5000/<short_code>

# Test statistics
curl http://localhost:5000/stats
```

## Kubernetes Resources

### Redis Deployment

- **Image**: `redis:7-alpine`
- **Replicas**: 1
- **Service**: ClusterIP on port 6379
- **Resources**: 128Mi memory, 250m CPU

### Application Deployment

- **Image**: `url-shortener:v1`
- **Replicas**: 2
- **Service**: NodePort on port 30080
- **Resources**: 256Mi memory, 500m CPU
- **Health Checks**: Liveness and readiness probes

## Scaling

### Horizontal Scaling

```bash
kubectl scale deployment url-shortener --replicas=5
```

### Vertical Scaling

Edit resource limits in `k8s/app.yaml`:

```yaml
resources:
  requests:
    memory: "512Mi"
    cpu: "1000m"
  limits:
    memory: "1Gi"
    cpu: "2000m"
```

## Monitoring

### View Logs

```bash
# Application logs
kubectl logs -f deployment/url-shortener

# Redis logs
kubectl logs -f deployment/redis
```

### Check Health

```bash
# Application health
kubectl get pods
kubectl describe pod <pod-name>

# Service endpoints
kubectl get endpoints url-shortener
```

## Troubleshooting

### Pod Not Starting

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Connection Issues

```bash
# Test Redis connectivity
kubectl exec -it <app-pod> -- nc -zv redis 6379

# Check service
kubectl get svc
```

### Image Pull Issues

```bash
# Verify image exists
sudo ctr -n k8s.io images ls | grep url-shortener

# Re-import image
sudo docker save url-shortener:v1 | sudo ctr -n k8s.io images import -
```

## Security Notes

- Redis has no authentication (suitable for development only)
- Consider implementing API rate limiting for production
- Add HTTPS support for production deployments
- Implement input validation and sanitization

## License

MIT License
