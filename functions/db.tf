resource "random_password" "db_creds" {
  length           = 16
  special          = true
  override_special = "&@"
}



resource "aws_secretsmanager_secret" "example" {
  name = "example"
}

resource "aws_secretsmanager_secret_version" "login" {
 secret_id = aws_secretsmanager_secret.example.id
 secret_string = <<EOF
 {
  "username" : "amdin2",
  "password" : "${random_password.db_creds.result}"
 }
 EOF
}


locals {
  db_creds = jsondecode(aws_secretsmanager_secret_version.login.secret_string)
}
# data "aws_secretsmanager_secret_version" "new_creds" {
#   secret_id = "new_creds"
# }
# locals {
#   db_creds = jsondecode(data.aws_secretsmanager_secret_version.new_creds.secret_string)
# }


resource "aws_db_subnet_group" "db_sub" {
  name = "db_subnet"
  tags = {
    Name = "db-subnet"
  }
  subnet_ids = aws_subnet.public-subnets.*.id
  
}





resource "aws_db_instance" "test-db" {
  allocated_storage    = 10
  identifier  = "mydb"
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = local.db_creds.username
  password             = local.db_creds.password
  parameter_group_name = "default.mysql5.7"
  publicly_accessible = true
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_sub.name
  tags = {
    Name = "MyDB"
  }
}