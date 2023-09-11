resource "aws_ecr_repository" "ecrdenzel" {
  name                 = "ecrrepo2"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}