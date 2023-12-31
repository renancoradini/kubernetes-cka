resource "tls_private_key" "terrafrom_generated_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {

  # Name of key: Write the custom name of your key
  key_name = "aws_keys_pairs"

  # Public Key: The public will be generated using the reference of tls_private_key.terrafrom_generated_private_key
  public_key = tls_private_key.terrafrom_generated_private_key.public_key_openssh

  # Store private key :  Generate and save private key(aws_keys_pairs.pem) in current directory
  provisioner "local-exec" {
    command = <<-EOT
       echo '${tls_private_key.terrafrom_generated_private_key.private_key_pem}' > aws_keys_pairs.pem
      chmod 400 aws_keys_pairs.pem
     EOT
  }
}

#  3. Connection Block-
#  connection {
#   type        = "ssh"
#   host        = self.public_ip
#   user        = "ubuntu"

#    # Mention the exact private key name which will be generated 
#    private_key = file("aws_keys_pairs.pem")
#    timeout     = "4m"

#  }
