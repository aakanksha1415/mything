#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "exit-assign-ak1-node" {
  name = "exit-assign-ak1-terraform-eks-node"

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

resource "aws_iam_role_policy_attachment" "exit-assign-ak1-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.exit-assign-ak1-node.name
}

resource "aws_iam_role_policy_attachment" "exit-assign-ak1-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.exit-assign-ak1-node.name
}

resource "aws_iam_role_policy_attachment" "exit-assign-ak1-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.exit-assign-ak1-node.name
}

resource "aws_eks_node_group" "exit-assign-ak1" {
  cluster_name    = aws_eks_cluster.exit-assign-ak1.name
  node_group_name = "exit-assign-ak1"
  node_role_arn   = aws_iam_role.exit-assign-ak1-node.arn
  subnet_ids      = aws_subnet.exit-assign-ak1[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.exit-assign-ak1-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.exit-assign-ak1-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.exit-assign-ak1-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
