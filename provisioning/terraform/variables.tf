variable "server_port" {
  description = "The port the server will use for HTTP requests"
}

variable "cidr_block" {
    description = "VPC cidr block"
}

variable "subnet_block" {
    description = "subnet cidr block"
}

variable "subnet_public_ip" {
    description = "map subnet to public ip"
}

variable "availability_zone" {
    description = "subnet availability zone"
}

variable "aws_key_name" {
  description = "EC2 acces key pair"
}


variable "aws_key_local_path" {
  description = "EC2 acces key pair local path"
}