[all:vars]
ansible_user=${ssh_user}
ansible_ssh_private_key_file=${ssh_key_file}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[masters]
master ansible_host=${master_ip} private_ip=${master_private_ip}

[workers]
%{ for idx, ip in worker_ips ~}
worker-${idx + 1} ansible_host=${ip} private_ip=${worker_private_ips[idx]}
%{ endfor ~}

[k8s_cluster:children]
masters
workers
