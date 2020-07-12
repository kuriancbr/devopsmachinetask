resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-aws-vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

/*
  NAT Instance
*/
resource "aws_security_group" "nat" {
  name        = "vpc_nat"
  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "NATSG"
  }
}

resource "aws_instance" "nat" {
  ami                         = "ami-02ae530dacc099fc9" # this is a special ami preconfigured to do NAT
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.nat.id}"]
  subnet_id                   = "${aws_subnet.us-east-1a-public.id}"
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name = "VPC Machine"
  }
}

resource "aws_eip" "nat" {
  instance = "${aws_instance.nat.id}"
  vpc      = true
}

/*
  Public Subnet
*/
resource "aws_subnet" "us-east-1a-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_route_table" "us-east-1a-public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_route_table_association" "us-east-1a-public" {
  subnet_id      = "${aws_subnet.us-east-1a-public.id}"
  route_table_id = "${aws_route_table.us-east-1a-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "us-east-1a-private" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block        = "${var.private_subnet_cidr}"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_route_table" "us-east-1a-private" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_route_table_association" "us-east-1a-private" {
  subnet_id      = "${aws_subnet.us-east-1a-private.id}"
  route_table_id = "${aws_route_table.us-east-1a-private.id}"
}

output "vpcmachine_ip" {
  value = "created a vpc machine which have limited access to web server and db machines"
}


