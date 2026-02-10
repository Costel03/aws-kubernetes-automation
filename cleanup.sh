#!/bin/bash

set -e

echo "Destroying Kubernetes Cluster"
echo "=============================="

read -p "Warning: This will destroy all AWS resources. Continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Cleanup cancelled."
    exit 1
fi

cd terraform

echo "Destroying infrastructure..."
terraform destroy -auto-approve

echo ""
echo "All resources have been destroyed."
