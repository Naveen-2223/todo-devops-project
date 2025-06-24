provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "devops_todo" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 (verify)
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [aws_security_group.todo_sg.name]

  tags = {
    Name = "DevOps-Todo"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt update"]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

resource "aws_security_group" "todo_sg" {
  name        = "todo_sg"
  description = "Allow 5000"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
