#!/bin/bash

set -e

echo "Deploying Kubernetes Cluster on AWS"
echo "===================================="

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v terraform &> /dev/null; then
    echo "Error: Terraform not found. Please install Terraform first."
    exit 1
fi

if ! command -v ansible &> /dev/null; then
    echo "Error: Ansible not found. Please install Ansible first."
    exit 1
fi

if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI not found. Please install AWS CLI first."
    exit 1
fi

# Check AWS credentials
echo "Verifying AWS credentials..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo "Error: AWS credentials not configured. Run 'aws configure' first."
    exit 1
fi

# Check SSH key
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi

# Deploy infrastructure
echo ""
echo "Deploying infrastructure with Terraform..."
cd terraform

terraform init
terraform plan
echo ""
read -p "Continue with deployment? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Deployment cancelled."
    exit 1
fi

terraform apply -auto-approve

echo ""
echo "Infrastructure deployed successfully!"
echo ""

# Wait for instances to be ready
echo "Waiting for instances to initialize..."
sleep 60

# Configure Kubernetes with Ansible
echo ""
echo "Configuring Kubernetes with Ansible..."
cd ../ansible

# Test connectivity
echo "Testing connectivity to nodes..."
if ! ansible all -m ping; then
    echo "Warning: Some nodes are not reachable. Waiting additional 30 seconds..."
    sleep 30
fi

# Run Ansible playbook
ansible-playbook site.yml

echo ""
echo "Kubernetes cluster deployed successfully!"
echo ""
echo "Cluster Information:"
cd ../terraform
terraform output

echo ""
echo "To access your cluster:"
echo ""
echo "1. SSH to master node:"
terraform output ssh_command_master | tr -d '"'
echo ""
echo "2. Check cluster status:"
echo "   kubectl get nodes"
echo ""
echo "3. Get kubeconfig locally:"
terraform output kubeconfig_command | tr -d '"'
echo ""
echo "Note: Run './cleanup.sh' when finished to destroy all resources."
