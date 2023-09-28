resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.terrafrom_generated_private_key.private_key_pem
  filename        = format("%s/%s/%s", abspath(path.root), ".ssh", "aws_keys_pairs.pem")
  file_permission = "0600"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tftpl", {
    ip_addrsm   = [for i in aws_instance.ec2_kubernetes_master : i.public_ip]
    ip_addrs    = [for i in aws_instance.ec2_kubernetes_workers : i.public_ip]
    ssh_keyfile = local_sensitive_file.private_key.filename
    aws_account = var.aws_account
  })
  filename = format("%s/%s", abspath(path.root), "inventory.ini")
}
