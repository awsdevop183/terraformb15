# locals {
#   ingress = [22, 80, 8090, 2222, 2020]
# }

resource "aws_security_group" "dynamic-sg" {
  name   = "dynamic-sg"
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "${var.vpc-name}-Dynamic-sg"
  }
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  dynamic "ingress" {
    for_each = var.rules
    content {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = ingress.value
      to_port          = ingress.value
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
    }

  }

}