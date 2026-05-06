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

resource "docker_network" "nginx_net" {
  name = "nginx-network-ex6"
}

resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = true
}

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

resource "docker_image" "curl" {
  name         = "appropriate/curl"
  keep_locally = true
}

resource "docker_container" "server" {

  for_each = toset(var.server_names)

  name  = "server-${each.value}"
  image = docker_image.curl.image_id

  networks_advanced {
    name = docker_network.nginx_net.name
  }

  command = [
    "sh",
    "-c",
    "curl http://${var.container_name}:80 && sleep 30"
  ]

  depends_on = [docker_container.nginx]
}