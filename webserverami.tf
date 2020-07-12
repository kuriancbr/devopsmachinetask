/*
  Web Servers
*/
resource "aws_security_group" "web" {
  name        = "vpc_web"
  description = "Allow incoming HTTP connections."

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
    Name = "WebServerSG"
  }
}

resource "aws_instance" "web-1" {
  ami                         = "${lookup(var.amis, var.aws_region)}"
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.web.id}"]
  subnet_id                   = "${aws_subnet.us-east-1a-public.id}"
  associate_public_ip_address = true
  source_dest_check           = false
  #following are the steps to install apache and wordpress to host the site
  #steps includes installation of apache server and it's configuration, firewall modification and wordpress installation
  #and it's configuration
  user_data = <<-EOF
          #!/bin/bash
          sudo apt-get update
          sudo apt-get upgrade -y
          sudo apt-get install apache2 -y
          sudo systemctl start apache2.service
          sudo systemctl enable apache2.service
          sudo apt-get install firewalld -y
          sudo firewall-cmd --zone=public --permanent --add-service=http
          sudo apt-get install php -y
          sudo apt-get install php-gd -y
          sudo apt-get install php-mysql -y
          cd /tmp
          sudo wget https://www.wordpress.org/latest.tar.gz
          sudo  mount -a
          sudo tar xzvf /tmp/latest.tar.gz --strip 1 -C /var/www/html
          sudo chown -R www-data /var/www/html/
          sudo systemctl restart firewalld.service
          sudo systemctl restart apache2.service
          EOF

  tags = {
    Name = "Web Server Machine"
  }


}

resource "aws_eip" "web-1" {
  instance = "${aws_instance.web-1.id}"
  vpc      = true
}

output "webserver_ip" {
  value = "wordpress server instance created and installed all requried packages"
}

