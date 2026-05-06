terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_key_pair" "deployer" {
  key_name = "deployer-key"
}

resource "aws_security_group" "wordpress" {
  name        = "wordpress-docker-sg"
  description = "Allow HTTP and SSH for WordPress Docker"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-docker-sg"
  }
}

resource "aws_instance" "wordpress" {
  ami                    = "ami-0d05471b100e9083f"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.wordpress.id]
  key_name               = data.aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker git
              service docker start
              usermod -a -G docker ec2-user
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              mkdir -p /opt/wordpress
              cd /opt/wordpress
              cat > docker-compose.yml <<'COMPOSE'
version: '3.8'
services:
  wordpress:
    image: wordpress:latest
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress123
    volumes:
      - wordpress_data:/var/www/html
    depends_on:
      - db
  
  db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress123
      MYSQL_ROOT_PASSWORD: rootpass123
    volumes:
      - db_data:/var/lib/mysql

volumes:
  wordpress_data:
  db_data:
COMPOSE
              /usr/local/bin/docker-compose up -d
              EOF

  tags = {
    Name = "wordpress-docker-instance"
  }
}
