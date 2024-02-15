resource "aws_vpc" "default" {
  cidr_block = var.vpc-cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc-name
  }


}
resource "aws_internet_gateway" "default-igw" {
  vpc_id = aws_vpc.default.id

}
resource "aws_subnet" "public-subnets" {
  vpc_id            = aws_vpc.default.id
  count             = length(var.subnets)
  availability_zone = element(var.azs, count.index)
  cidr_block        = var.subnets[count.index]
  tags = {
    Name = "${var.vpc-name}-pub-sub-${count.index + 1}"
  }
  map_public_ip_on_launch = true

}




resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "${var.vpc-name}-Public-RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default-igw.id
  }
}



resource "aws_route_table_association" "public" {
  count          = length(var.subnets)
  route_table_id = aws_route_table.pub-rt.id

  subnet_id = aws_subnet.public-subnets.*.id[count.index]

}




