# Contributing Guidelines

Thank you for your interest in contributing to this project. This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help maintain a positive environment

## How to Contribute

### Reporting Issues

1. Check existing issues to avoid duplicates
2. Provide clear description of the problem
3. Include steps to reproduce
4. Specify your environment (OS, versions, etc.)
5. Add relevant logs or error messages

### Submitting Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages
6. Push to your fork
7. Open a Pull Request

### Pull Request Guidelines

- Provide clear description of changes
- Reference related issues
- Ensure all tests pass
- Update documentation as needed
- Follow existing code style
- Keep changes focused and atomic

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/terraform_ansible_aws.git
cd terraform_ansible_aws

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/terraform_ansible_aws.git

# Create branch
git checkout -b feature/your-feature

# Make changes and commit
git add .
git commit -m "Description of changes"

# Push to your fork
git push origin feature/your-feature
```

## Code Style

### Terraform

- Use consistent formatting (`terraform fmt`)
- Add comments for complex resources
- Use meaningful variable names
- Group related resources together

### Ansible

- Follow YAML best practices
- Use descriptive task names
- Add comments for complex logic
- Keep playbooks modular

### Shell Scripts

- Use shellcheck for validation
- Add error handling (`set -e`)
- Include helpful output messages
- Document parameters

### Python

- Follow PEP 8 style guide
- Add docstrings to functions
- Include type hints where appropriate
- Write unit tests

## Testing

Before submitting:

```bash
# Validate Terraform
cd terraform
terraform fmt -check
terraform validate

# Test Ansible syntax
cd ../ansible
ansible-playbook site.yml --syntax-check

# Test shell scripts
shellcheck deploy.sh cleanup.sh
```

## Documentation

- Update README.md for new features
- Add inline comments for complex code
- Document configuration options
- Include usage examples

## Commit Messages

Format:
```
type: Short description (max 72 chars)

Longer explanation if needed. Wrap at 72 characters.

- Bullet points are okay
- Use present tense: "Add feature" not "Added feature"
- Reference issues: Fixes #123
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test additions or changes
- `chore`: Build process or tooling changes

## Release Process

Maintainers will:
1. Review and merge pull requests
2. Update version numbers
3. Create release tags
4. Update changelog

## Questions?

- Open an issue for general questions
- Tag maintainers for urgent matters
- Check documentation first

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
