# Quick Start Guide

Fast track guide for deploying your Kubernetes cluster on AWS.

## Prerequisites Check

```bash
terraform version  # >= 1.0
ansible --version  # >= 2.9
aws --version      # >= 2.0
```

## Setup (5 minutes)

### 1. AWS Credentials

```bash
aws configure
```

Enter your Access Key ID and Secret Access Key.

### 2. SSH Key

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

## Deploy (10-15 minutes)

### Option 1: Automated

```bash
./deploy.sh
```

### Option 2: Manual

```bash
# Infrastructure
cd terraform
terraform init
terraform apply

# Kubernetes
cd ../ansible
ansible-playbook site.yml
```

## Verify

```bash
# Get master IP
cd terraform
terraform output master_public_ip

# Connect
ssh -i ~/.ssh/id_rsa ubuntu@<MASTER_IP>

# Check cluster
kubectl get nodes
kubectl get pods --all-namespaces
```

## Deploy Sample App

```bash
cd url-shortener
./deploy.sh
```

Access at: `http://<MASTER_IP>:30080`

## Cleanup

```bash
./cleanup.sh
```

## Common Commands

```bash
# View infrastructure
cd terraform
terraform show

# Check Ansible inventory
cd ansible
cat inventory

# View logs
ssh -i ~/.ssh/id_rsa ubuntu@<MASTER_IP>
kubectl logs <pod-name>

# Scale application
kubectl scale deployment url-shortener --replicas=3
```

## Costs

- **Hourly**: ~$0.08/hour
- **Daily**: ~$2/day
- **Monthly**: ~$65/month

**Remember**: Run `./cleanup.sh` when done to stop charges.

## Troubleshooting

### Can't connect to master

```bash
aws ec2 describe-instances --filters "Name=tag:Name,Values=*master*"
```

### Terraform errors

```bash
cd terraform
terraform validate
terraform refresh
```

### Kubernetes not ready

```bash
ssh -i ~/.ssh/id_rsa ubuntu@<MASTER_IP>
sudo systemctl status kubelet
kubectl get nodes
```

## Next Steps

- [Full Documentation](README.md)
- [URL Shortener Guide](url-shortener/README.md)
- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)
