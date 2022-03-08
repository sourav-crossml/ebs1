output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet-1"{
  value = aws_subnet.public-subnet-1.id
}
output "subnet-2"{
  value = aws_subnet.public-subnet-2.id
}
output "subnet-3"{
  value = aws_subnet.private-subnet-1.id
}
output "subnet-4"{
  value = aws_subnet.private-subnet-2.id
}
# output "subnet-5"{
#   value = aws_subnet.private-subnet-3.id
# }
# output "subnet-6"{
#   value = aws_subnet.private-subnet-4.id
# }