data "aws_availability_zones" "available" {
  state = "available"
}
#resource "aws_default_subnet" "subnet" {
#  count = 2
#  availability_zone       = data.aws_availability_zones.available.names[count.index]
#  tags = {
#    Name = "TF_EKS"
#  }
#}
resource "aws_subnet" "subnet1" {
#  count = 2
#  availability_zone       = data.aws_availability_zones.available.names[count.index]
  availability_zone       = "us-west-2a"
  cidr_block              = "172.31.0.0/18"
  map_public_ip_on_launch = true
  vpc_id                  = aws_default_vpc.vpc.id
}


resource "aws_subnet" "subnet2" {
  availability_zone       = "us-west-2b"
  cidr_block              = "172.31.64.0/18"
  map_public_ip_on_launch = true
  vpc_id                  = aws_default_vpc.vpc.id
}

resource "aws_default_vpc" "vpc" {
  tags = {
    Name = "TF_EKS"
  }
}










  
    
