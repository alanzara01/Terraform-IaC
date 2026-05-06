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

# réseau docker
resource "docker_network" "nginx_net" {
  name = "nginx-network"
}

# image nginx
resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = true
}

# container nginx
resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.nginx_net.name
  }

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}

# image curl
resource "docker_image" "curl" {
  name         = "appropriate/curl"
  keep_locally = true
}

# container client
resource "docker_container" "client" {
  name  = "curl-client"
  image = docker_image.curl.image_id

  networks_advanced {
    name = docker_network.nginx_net.name
  }

  command = [
    "sh",
    "-c",
    "curl http://${var.container_name}:80 && sleep 3600"
  ]

  depends_on = [docker_container.nginx]
}