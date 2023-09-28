# 1. EC2 Instance for Kubernetes Cluster
resource "aws_instance" "ec2_kubernetes_master" {
  count         = 1
  ami           = var.image_kubernetes_id
  instance_type = var.instance_type

  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.public.id, aws_security_group.ec2_ecs_instance.id]
  associate_public_ip_address = "true"
  # 2. Key Name
  # Specify the key name and it should match with key_name from the resource "aws_key_pair"
  key_name             = aws_key_pair.generated_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  tags = {
    Name = "Kubernetes Master Controller"
  }

}


# 2. EC2 Instance for Kubernetes Workers
resource "aws_instance" "ec2_kubernetes_workers" {
  count         = var.count_kub_instances
  ami           = var.image_kubernetes_id
  instance_type = var.instance_type

  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.public.id, aws_security_group.ec2_ecs_instance.id]
  associate_public_ip_address = "true"
  # 2. Key Name
  # Specify the key name and it should match with key_name from the resource "aws_key_pair"
  key_name = aws_key_pair.generated_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  tags = {
    Name = "Kubernetes Workers"
  }
}

resource "aws_lb_target_group_attachment" "kubernete_target_group" {

  # covert a list of instance objects to a map with instance ID as the key, and an instance
  # object as the value.
  for_each = {
    for k, v in aws_instance.ec2_kubernetes_workers :
    v.id => v
  }

  target_group_arn = aws_alb_target_group.alb_public_webservice_target_group.arn
  target_id        = each.value.id
  port             = 80
  depends_on       = [aws_instance.ec2_kubernetes_workers]
}



resource "null_resource" "ansible-check-conn-ec2s" {
  provisioner "remote-exec" {
    connection {
      host        = aws_instance.ec2_kubernetes_workers[2].public_ip
      user        = "ubuntu"
      private_key = file(local_sensitive_file.private_key.filename)

    }
    inline = ["echo 'Estou conectaaaaaaaado!'"]
  }
  provisioner "local-exec" {
    working_dir = "../ansible"
    command     = "ansible-playbook -i ../terraformar/inventory.ini playbooks/kubernetes_playbook.yaml"
  }
  depends_on = [aws_key_pair.generated_key]
}

##Auto Scale Group

resource "aws_autoscaling_group" "tf2" {
  desired_capacity = 0 #set to what you like; must be same number as min
  max_size         = 0 #set to what you like
  min_size         = 0 #set to what you like; must be same as desired capacity
  vpc_zone_identifier = [
  module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]] #two subnets

  health_check_type = "ELB"
  # Apenas necessario se for ELB, ALB funciona pelo target group
  # load_balancers = [aws_lb.loadbalancer.id]
  target_group_arns = [aws_alb_target_group.alb_public_webservice_target_group.arn]

  launch_template {
    id      = aws_launch_template.tf_launch_template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity, max_size, min_size]
  }
}

## In the future change the security group of instance to talk
#  only with LB

resource "aws_launch_template" "tf_launch_template" {
  name_prefix   = "tf-launch_template"
  image_id      = var.image_ecs_id  #in variable file
  instance_type = var.instance_type #in variable file
  key_name      = aws_key_pair.generated_key.key_name

  user_data = base64encode(file("user_data.sh"))
  #vpc_security_group_ids    = [aws_security_group.public.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_agent.name
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.public.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "terraform_auto_scaling"
    }
  }
}

# data "template_file" "user_data" {
#   template = file("user_data.tpl") #Defines a script that runs when the EC2 instance starts
# }
