/*
  Database Servers
*/
resource "aws_security_group" "db" {
  name        = "vpc_db"
  description = "Allow incoming database connections."

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
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "DBServerSG"
  }
}

resource "aws_instance" "db-1" {
  ami                    = "${lookup(var.amis, var.aws_region)}"
  availability_zone      = "us-east-1a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  subnet_id              = "${aws_subnet.us-east-1a-private.id}"
  source_dest_check      = false




  tags = {
    Name = "DB Server Machine"
  }
}

output "database_ami" {
  value = "database ami successfully creaed in was us-east-1"
}

