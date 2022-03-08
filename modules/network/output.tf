output "igw" {
    value = aws_internet_gateway.gw.id
}

output "nat1" {
    value = aws_nat_gateway.nat_1.id
}

# output "nat2" {
#     value = aws_nat_gateway.nat_2.id
# }

output "eip" {
  value = aws_eip.eip.id
}