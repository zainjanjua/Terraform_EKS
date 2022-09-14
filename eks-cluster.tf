
resource "aws_iam_role" "masternode_role" {
  name = "eks_masternode_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "EKSPolicy1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.masternode_role.name
}

resource "aws_iam_role_policy_attachment" "EKSPolicy2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.masternode_role.name
}

resource "aws_security_group" "SG" {
  name        = "AWS_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_EKS"
  }
}

resource "aws_eks_cluster" "EKS" {
  name     = "EKSmasternode"
  role_arn = aws_iam_role.masternode_role.arn
  vpc_config {
    security_group_ids = [aws_security_group.SG.id]
    subnet_ids         = [aws_subnet.subnet1.id,aws_subnet.subnet2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.EKSPolicy1,
    aws_iam_role_policy_attachment.EKSPolicy2,
  ]
}
