terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}

provider "docker" {
  host = "tcp://localhost:2375"
}

resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = true
}

resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}

resource "null_resource" "test_nginx" {

  depends_on = [docker_container.nginx]

  provisioner "local-exec" {
    command = "curl http://localhost:${var.external_port} | findstr Welcome"
  }
}