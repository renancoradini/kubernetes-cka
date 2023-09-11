# 1. EC2 Instance for teste and SSH
resource "aws_instance" "ec2_ssh" {

  ami           = var.image_ecs_id
  instance_type = var.instance_type

  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.public.id]
  associate_public_ip_address = "true"


  # 2. Key Name
  # Specify the key name and it should match with key_name from the resource "aws_key_pair"
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name = "Terraform - using tls_private_key module"
  }
}

##Auto Scale Group

resource "aws_autoscaling_group" "tf2" {
  desired_capacity = 2 #set to what you like; must be same number as min
  max_size         = 4 #set to what you like
  min_size         = 2 #set to what you like; must be same as desired capacity
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
