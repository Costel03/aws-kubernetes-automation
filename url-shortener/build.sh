#!/bin/bash
set -e

echo "Building URL Shortener Docker image..."
docker build -t url-shortener:v1 .

echo ""
echo "✓ Image built successfully!"
echo ""
echo "To push to Docker Hub:"
echo "  docker tag url-shortener:v1 YOUR_USERNAME/url-shortener:v1"
echo "  docker push YOUR_USERNAME/url-shortener:v1"
