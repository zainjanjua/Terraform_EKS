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
resource "aws_subnet" "subnet" {
  count = 2
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_default_vpc.vpc.id
}
resource "aws_default_vpc" "vpc" {
  tags = {
    Name = "TF_EKS"
  }
}










  
    
