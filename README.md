# Kubernetes on AWS - Infrastructure Automation

Production-ready Kubernetes cluster deployment on AWS using Infrastructure as Code (IaC) principles with Terraform and Ansible.

## Overview

This repository automates the complete deployment of a Kubernetes cluster on AWS infrastructure. It provides a reliable, repeatable infrastructure provisioning process suitable for development, testing, and production environments.

## Features

- **Automated Infrastructure Provisioning**: Complete AWS VPC, networking, and compute resources via Terraform
- **Kubernetes Cluster Setup**: Automated multi-node cluster configuration using Ansible
- **Production-Ready Architecture**: Secure VPC design with proper networking and security groups
- **Scalable Design**: Easily adjust cluster size and node specifications
- **Sample Application**: URL shortener microservice demonstrating Kubernetes deployment

## Architecture

```
┌──────────────────────────────────────────────────────┐
│                      AWS VPC                          │
│  ┌────────────────────────────────────────────────┐  │
│  │         Public Subnet (10.0.1.0/24)           │  │
│  │                                                │  │
│  │  ┌──────────────┐      ┌──────────────┐      │  │
│  │  │ Master Node  │      │ Worker Node  │      │  │
│  │  │  (t3.medium) │──────│  (t3.small)  │      │  │
│  │  └──────────────┘      └──────────────┘      │  │
│  │                                                │  │
│  └───────────────────┬────────────────────────────┘  │
│                      │                               │
│              Internet Gateway                         │
└──────────────────────┼───────────────────────────────┘
                       │
                  Internet
```

## Prerequisites

- **AWS Account** with appropriate IAM permissions
- **AWS CLI** (>= 2.0) configured with credentials
- **Terraform** (>= 1.0)
- **Ansible** (>= 2.9)
- **SSH key pair** for EC2 instance access

## Quick Start

### 1. Configure AWS Credentials

```bash
aws configure
```

Provide your AWS Access Key ID, Secret Access Key, and preferred region.

### 2. Generate SSH Key

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

### 3. Deploy Infrastructure

```bash
./deploy.sh
```

The deployment script will:
- Validate prerequisites
- Initialize and apply Terraform configuration
- Execute Ansible playbooks for cluster setup
- Output cluster access information

### 4. Access Your Cluster

After successful deployment, connect to the master node:

```bash
ssh -i ~/.ssh/id_rsa ubuntu@<MASTER_IP>
kubectl get nodes
```

## Configuration

### Terraform Variables

Customize your deployment by creating `terraform/terraform.tfvars`:

```hcl
aws_region           = "us-east-1"
cluster_name         = "k8s-cluster"
worker_count         = 2
master_instance_type = "t3.medium"
worker_instance_type = "t3.small"
vpc_cidr            = "10.0.0.0/16"
subnet_cidr         = "10.0.1.0/24"
```

### Available Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region for deployment | `us-east-1` |
| `cluster_name` | Cluster identifier | `k8s-cluster` |
| `worker_count` | Number of worker nodes | `2` |
| `master_instance_type` | Master node EC2 instance type | `t3.medium` |
| `worker_instance_type` | Worker node EC2 instance type | `t3.small` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `subnet_cidr` | Subnet CIDR block | `10.0.1.0/24` |

## Manual Deployment

### Infrastructure Provisioning

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Cluster Configuration

```bash
cd ansible
ansible-playbook -i inventory site.yml
```

## Sample Application

The repository includes a URL shortener microservice demonstrating Kubernetes deployment patterns.

### Deploy URL Shortener

```bash
cd url-shortener
./deploy.sh
```

The application will be accessible at: `http://<MASTER_IP>:30080`

### Application Features

- RESTful URL shortening API
- Redis backend for data persistence
- Kubernetes-native deployment with health checks
- Horizontal scaling with multiple replicas

## Infrastructure Components

### Terraform Resources

- **VPC**: Isolated network environment
- **Subnet**: Public subnet for cluster nodes
- **Internet Gateway**: External connectivity
- **Security Group**: Firewall rules for cluster communication
- **EC2 Instances**: Kubernetes master and worker nodes
- **Elastic IPs**: Static public IP addresses

### Ansible Playbooks

- **Common Setup**: Container runtime and Kubernetes components
- **Master Setup**: Control plane initialization and CNI configuration
- **Worker Setup**: Worker node cluster joining

## Cleanup

Destroy all AWS resources to avoid charges:

```bash
./cleanup.sh
```

Or manually:

```bash
cd terraform
terraform destroy
```

## Cost Estimation

Approximate monthly costs (us-east-1):

| Component | Type | Monthly Cost |
|-----------|------|--------------|
| Master Node | t3.medium | ~$30 |
| Worker Node (x2) | t3.small | ~$30 |
| Networking | Data transfer | ~$5 |
| **Total** | | **~$65** |

*Prices are estimates and may vary by region and usage.*

## Security Considerations

- SSH access restricted to public key authentication
- Security groups limit traffic to necessary ports only
- Regular updates recommended for Kubernetes and OS packages
- Consider implementing AWS IAM roles for EC2 instances
- Use AWS Secrets Manager for sensitive data in production

## Troubleshooting

### Connection Issues

```bash
# Verify SSH connectivity
ssh -i ~/.ssh/id_rsa ubuntu@<MASTER_IP>

# Check security group rules
aws ec2 describe-security-groups --group-ids <SG_ID>
```

### Kubernetes Issues

```bash
# Check cluster status
kubectl get nodes
kubectl get pods --all-namespaces

# View logs
kubectl logs <POD_NAME>
```

### Terraform Issues

```bash
# Validate configuration
terraform validate

# View current state
terraform show

# Force refresh state
terraform refresh
```

## Directory Structure

```
.
├── terraform/          # Infrastructure as Code
│   ├── main.tf        # AWS resources definition
│   ├── variables.tf   # Input variables
│   ├── outputs.tf     # Output values
│   └── inventory.tpl  # Ansible inventory template
├── ansible/           # Configuration management
│   ├── ansible.cfg    # Ansible configuration
│   ├── site.yml       # Main playbook
│   └── playbooks/     # Component playbooks
├── url-shortener/     # Sample application
│   ├── app.py         # Flask application
│   ├── Dockerfile     # Container definition
│   └── k8s/           # Kubernetes manifests
├── deploy.sh          # Automated deployment script
└── cleanup.sh         # Resource cleanup script
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

MIT License - See LICENSE file for details

## Support

For issues and questions:
- Open an issue in the repository
- Review existing documentation
- Check Terraform and Ansible official documentation

## Acknowledgments

- Kubernetes project
- Terraform by HashiCorp
- Ansible by Red Hat
- AWS Cloud Platform
