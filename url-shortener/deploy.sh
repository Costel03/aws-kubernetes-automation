#!/bin/bash
set -e

# Get master IP from Terraform output
cd ../terraform
MASTER_IP=$(terraform output -raw master_public_ip 2>/dev/null || echo "")
cd ../url-shortener

if [ -z "$MASTER_IP" ]; then
    echo "Error: Could not get master IP from Terraform."
    echo "Please set MASTER_IP manually or run Terraform first."
    exit 1
fi

SSH_KEY="~/.ssh/id_rsa"

echo "Deploying URL Shortener to Kubernetes"
echo "======================================"
echo "Master IP: $MASTER_IP"
echo ""

# Copy files to master node
echo "Copying files to master node..."
scp -i $SSH_KEY -r ../url-shortener ubuntu@$MASTER_IP:~/

# Build Docker image on master
echo ""
echo "Building Docker image..."
ssh -i $SSH_KEY ubuntu@$MASTER_IP << 'ENDSSH'
cd ~/url-shortener
sudo docker build -t url-shortener:v1 .
echo "Image built successfully"
ENDSSH

# Load image into containerd
echo ""
echo "Loading image into containerd..."
ssh -i $SSH_KEY ubuntu@$MASTER_IP << 'ENDSSH'
cd ~/url-shortener
sudo docker save url-shortener:v1 | sudo ctr -n k8s.io images import -
echo "Image loaded successfully"
ENDSSH

# Deploy to Kubernetes
echo ""
echo "Deploying to Kubernetes..."
ssh -i $SSH_KEY ubuntu@$MASTER_IP << 'ENDSSH'
cd ~/url-shortener/k8s

# Deploy Redis
echo "Deploying Redis..."
kubectl apply -f redis.yaml
kubectl wait --for=condition=ready pod -l app=redis --timeout=60s

# Deploy URL Shortener
echo "Deploying application..."
kubectl apply -f app.yaml
kubectl wait --for=condition=ready pod -l app=url-shortener --timeout=120s

echo ""
echo "Deployment complete"
ENDSSH

# Get access info
echo ""
echo "Getting access information..."
echo ""
ssh -i $SSH_KEY ubuntu@$MASTER_IP << ENDSSH
echo "================================"
echo "URL Shortener Deployed"
echo "================================"
echo ""

NODEPORT=\$(kubectl get svc url-shortener -o jsonpath='{.spec.ports[0].nodePort}')

echo "Access URL: http://$MASTER_IP:\${NODEPORT}"
echo ""
echo "Pods:"
kubectl get pods -l app=url-shortener
kubectl get pods -l app=redis
echo ""
echo "================================"
ENDSSH

echo ""
echo "Deployment completed successfully"
echo ""
