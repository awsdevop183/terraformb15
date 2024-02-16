output "vpc-id" {
    value = aws_vpc.default.id 
}

output "public-sub-1" {
    value = aws_subnet.public-subnets.0.id
}
output "vpc-name" {
    value = var.vpc-name
  
}