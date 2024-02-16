module "vpc" {
    source = "../network"
    vpc-name = "module"
    vpc-cidr = "192.168.0.0/16"
    subnets = ["192.168.4.0/24", "192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
    azs = ["us-east-1a","us-east-1b","us-east-1c"]
  
}
module "security" {
    source ="../security-groups"
    rules = [22,80]
    vpc_id = module.vpc.vpc-id
    vpc-name = "module"
    
}

resource "aws_instance" "testec2" {
    ami = "ami-0c7217cdde317cfec"
    instance_type = "t2.micro"
    subnet_id = module.vpc.public-sub-1
    key_name = "corp_key"
    security_groups = [module.security.sg-id]
}

output "my-pip" {
    value = aws_instance.testec2.public_ip
  
}

