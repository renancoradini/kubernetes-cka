
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]]

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_db_instance" "name1db" {
  allocated_storage    = 5
  storage_type         = "gp2"
  instance_class       = "db.t3.micro"
  identifier           = "name1db"
  engine               = "postgres"
  engine_version       = "14"
  parameter_group_name = "default.postgres14"
  db_subnet_group_name = aws_db_subnet_group.default.name
  db_name              = var.namedb
  username             = var.usernameDB
  password             = var.passwordDB

  vpc_security_group_ids = [aws_security_group.postgres.id]
  publicly_accessible    = true # Only for testing!!!
  skip_final_snapshot    = true
}