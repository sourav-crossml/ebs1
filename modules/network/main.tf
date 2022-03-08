
# Creating internet gateway
resource "aws_internet_gateway" "gw" {
    # vpc_id = aws_vpc.vpc.id
    vpc_id = var.vpc_id

  tags = {
    Name = "main"
  }
}

# Creating EIP 
resource "aws_eip" "eip" {
  vpc = true
  depends_on = [aws_internet_gateway.gw]
}


resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.eip.id
  subnet_id     = var.subnet_id-1

  tags = {
    Name = "NAT-1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

# resource "aws_nat_gateway" "nat_2" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = var.subnet_id-2

#   tags = {
#     Name = "NAT-2"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.gw]
# }
