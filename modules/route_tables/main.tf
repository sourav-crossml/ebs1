
#route table public1
resource "aws_route_table" "public1" {
  vpc_id = var.vpc_id

  route{
        cidr_block = "0.0.0.0/0"

    # Identifier of a VPC internet gateway or a virtual private gateway.
        gateway_id = var.igw_id
  }

  tags = {
    Name = "public1"
  }
}
#route table public2
resource "aws_route_table" "public2" {
  vpc_id = var.vpc_id

  route{
        cidr_block = "0.0.0.0/0"

    # Identifier of a VPC internet gateway or a virtual private gateway.
        gateway_id = var.igw_id
  }

  tags = {
    Name = "public2"
  }
}
#route table private1
resource "aws_route_table" "private1" {
  vpc_id = var.vpc_id

  route{
        cidr_block = "0.0.0.0/0"

    # Identifier of a VPC NAT gateway or a virtual private gateway.
        gateway_id = var.nat_id-1
  }

  tags = {
    Name = "private1"
  }
}
#route table private2
resource "aws_route_table" "private2" {
  vpc_id = var.vpc_id

  route{
        cidr_block = "0.0.0.0/0"

    # Identifier of a VPC NAT gateway or a virtual private gateway.
        gateway_id = var.nat_id-2
  }

  tags = {
    Name = "private2"
  }
}
