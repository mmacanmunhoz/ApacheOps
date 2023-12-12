resource "aws_vpc" "this" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "cloudbooks-vpc"
  }
}