# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-03

### Added
- Initial release
- Terraform infrastructure provisioning for AWS
- Ansible playbooks for Kubernetes cluster setup
- Automated deployment scripts
- URL shortener sample application
- Comprehensive documentation
- MIT License
- Contributing guidelines

### Infrastructure
- VPC with public subnet configuration
- Security groups with required ports
- EC2 instances (1 master + configurable workers)
- Dynamic Ansible inventory generation

### Kubernetes
- Automated master node initialization
- Worker node joining process
- Flannel CNI network setup
- Sample application deployment

### Documentation
- Professional README with setup instructions
- API documentation for sample application
- Troubleshooting guide
- Architecture diagrams

## [Unreleased]

### Planned
- Multi-region support
- High availability configuration
- Monitoring and logging integration
- CI/CD pipeline examples
- Additional sample applications
