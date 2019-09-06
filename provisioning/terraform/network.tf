resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "notesapp"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.subnet_block}"
  map_public_ip_on_launch = "${var.subnet_public_ip}" 
  availability_zone       = "${var.availability_zone}"

  tags = {
   Name = "notesapp"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "notesapp"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  
  tags  = {
        Name = "notesapp"
    }
} 