output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_a.id
}

output "private_subnet_a_id" {
  value = aws_subnet.private_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_b.id
}

output "private_subnet_b_id" {
  value = aws_subnet.private_b.id
}

output "public_subnet_c_id" {
  value = aws_subnet.public_c.id
}

output "private_subnet_c_id" {
  value = aws_subnet.private_c.id
}
