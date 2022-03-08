

resource "aws_route_table_association" "public1" {
  # The subnet ID to create an association.
  subnet_id = var.pub-1

  # The ID of the routing table to associate with.
  route_table_id = var.route_table_pub-1
}

resource "aws_route_table_association" "public2" {
  # The subnet ID to create an association.
  subnet_id = var.pub-2

  # The ID of the routing table to associate with.
  route_table_id = var.route_table_pub-2
}

resource "aws_route_table_association" "private1" {
  # The subnet ID to create an association.
  subnet_id = var.pvt-1

  # The ID of the routing table to associate with.
  route_table_id = var.route_table_pvt-1
}

resource "aws_route_table_association" "private2" {
  # The subnet ID to create an association.
  subnet_id = var.pvt-2

  # The ID of the routing table to associate with.
  route_table_id = var.route_table_pvt-2
}