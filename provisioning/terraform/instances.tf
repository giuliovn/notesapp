resource "aws_instance" "app" {
  ami = "ami-0be769204fc3cab51"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.app.id}"]
  subnet_id = "${aws_subnet.subnet.id}"
  key_name = "${var.aws_key_name}"

  tags = {
    Name = "notesapp"
    Type = "app"
  }
}

resource "aws_instance" "db" {
  ami = "ami-0be769204fc3cab51"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  subnet_id = "${aws_subnet.subnet.id}"
  key_name = "${var.aws_key_name}"

  tags = {
    Name = "notesapp"
    Type = "db"
  }
}

resource "aws_security_group" "app" {
  name = "notesapp-app-secgroup"

  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "notesapp"
  }
}

resource "aws_security_group" "db" {
  name = "notesapp-db-secgroup"

  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = ["${aws_security_group.app.id}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "notesapp"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.aws_key_name
  public_key = "${file("${var.aws_key_local_path}")}"
}