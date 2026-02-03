output "master_public_ip" {
  description = "Public IP address of the master node"
  value       = aws_instance.k8s_master.public_ip
}

output "master_private_ip" {
  description = "Private IP address of the master node"
  value       = aws_instance.k8s_master.private_ip
}

output "worker_public_ips" {
  description = "Public IP addresses of worker nodes"
  value       = aws_instance.k8s_worker[*].public_ip
}

output "worker_private_ips" {
  description = "Private IP addresses of worker nodes"
  value       = aws_instance.k8s_worker[*].private_ip
}

output "ssh_command_master" {
  description = "SSH command to connect to master node"
  value       = "ssh -i ${var.private_key_path} ${var.ssh_user}@${aws_instance.k8s_master.public_ip}"
}

output "kubeconfig_command" {
  description = "Command to get kubeconfig from master"
  value       = "scp -i ${var.private_key_path} ${var.ssh_user}@${aws_instance.k8s_master.public_ip}:~/.kube/config ./kubeconfig"
}
