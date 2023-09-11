#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "exit-assign-ak1" {
  cidr_block = "10.0.0.0/16"

  tags = tomap({
    "Name"                                      = "exit-assign-ak1-terraform-eks-node",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}

resource "aws_subnet" "exit-assign-ak1" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.exit-assign-ak1.id

  tags = tomap({
    "Name"                                      = "exit-assign-ak1-terraform-eks-node",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}

resource "aws_internet_gateway" "exit-assign-ak1" {
  vpc_id = aws_vpc.exit-assign-ak1.id

  tags = {
    Name = "exit-assign-ak1-terraform-eks"
  }
}

resource "aws_route_table" "exit-assign-ak1" {
  vpc_id = aws_vpc.exit-assign-ak1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.exit-assign-ak1.id
  }
}

resource "aws_route_table_association" "exit-assign-ak1" {
  count = 2

  subnet_id      = aws_subnet.exit-assign-ak1[count.index].id
  route_table_id = aws_route_table.exit-assign-ak1.id
}
