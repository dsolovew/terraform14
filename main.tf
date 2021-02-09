provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "server_group" {
  name = "Server Security Group"
  description = "Ingress Egress rules for server"

  dynamic "ingress" {
      for_each = ["22"]
      content {
          from_port = ingress.value
          to_port   = ingress.value
          protocol  = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
      }
  }

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "outbount rule"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  } 
}

resource "aws_instance" "server1" {
  ami           = "ami-0a91cd140a1fc148a"
  instance_type = "t3.micro"
  key_name      = "ssh-key"
  vpc_security_group_ids = [aws_security_group.server_group.id]
  tags = {
    "Name"  = "Server1"
    "Owner" = "Denis Solovyev"
  }
  depends_on = [ aws_instance.server3 ]
}

resource "aws_instance" "server2" {
  ami           = "ami-0a91cd140a1fc148a"
  instance_type = "t3.micro"
  key_name      = "ssh-key"
  vpc_security_group_ids = [aws_security_group.server_group.id]
  tags = {
    "Name"  = "Server2"
    "Owner" = "Denis Solovyev"
  }
  depends_on = [ aws_instance.server3 ]
}

resource "aws_instance" "server3" {
  ami           = "ami-0a91cd140a1fc148a"
  instance_type = "t3.micro"
  key_name      = "ssh-key"
  vpc_security_group_ids = [aws_security_group.server_group.id]
  tags = {
    "Name"  = "Server3"
    "Owner" = "Denis Solovyev"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = "ssh-key"
  public_key = file("/root/.ssh/ssh-key-pub.pub")
}