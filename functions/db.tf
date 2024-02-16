# resource "aws_db_subnet_group" "db-subnet-gp" {
#   name       = "mydb-subnets"
#   subnet_ids = ["${aws_subnet.public-subnets.0.id}","${aws_subnet.public-subnets.1.id}"]
#   #subnet_ids = ["${aws_subnet.public-subnets.*.id}"]
#   tags = {
#     Name = "My DB subnet group"
#   }
# }
# #=============================

# resource "aws_secretsmanager_secret" "newcreds" {
#   name = "sqldbcreds"
# }

# resource "aws_secretsmanager_secret_version" "newcredsversion" {
#   secret_id     = aws_secretsmanager_secret.newcreds.id
#   secret_string = <<EOF
#   {
#     "username" : "admin",
#     "password" : "${random_password.mypass.result}"
#     }
#   EOF
  
# }


# #==================

# locals {
#   rds=jsondecode(aws_secretsmanager_secret_version.newcredsversion.secret_string)
# }

# resource "aws_db_instance" "testdb" {
#   allocated_storage    = 10
#   db_name              = "mydb2"
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t3.micro"
#   username             = local.rds.username
#   password             = local.rds.password
#   parameter_group_name = "default.mysql5.7"
#   skip_final_snapshot  = true
#   publicly_accessible = true
#   db_subnet_group_name  = aws_db_subnet_group.db-subnet-gp.name
#   vpc_security_group_ids = ["${aws_security_group.default-sg.id}"]
#   identifier = "mydb2"
#   tags = {
#     Name = "MyDB2"
#   }
# }