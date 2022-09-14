
resource "aws_iam_role" "workernode_role" {
  name = "eks_workernode_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eksPolicy3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workernode_role.name
}

resource "aws_iam_role_policy_attachment" "eksPolicy4" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workernode_role.name
}

resource "aws_iam_role_policy_attachment" "eksPolicy5" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workernode_role.name
}

resource "aws_eks_node_group" "ekswokernode" {
  cluster_name    = aws_eks_cluster.EKS.name
  node_group_name = "eksworkernode"
  node_role_arn   = aws_iam_role.workernode_role.arn
  subnet_ids      = [aws_subnet.subnet[*].id]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eksPolicy3,
    aws_iam_role_policy_attachment.eksPolicy4,
    aws_iam_role_policy_attachment.eksPolicy5,
  ]
}
