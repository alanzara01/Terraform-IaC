variable "image_name" {
  description = "Image nginx"
  type        = string
  default     = "nginx:latest"
}

variable "container_name" {
  description = "Nom du conteneur nginx"
  type        = string
  default     = "nginx-ex6"
}

variable "internal_port" {
  description = "Port interne nginx"
  type        = number
  default     = 80
}

variable "external_port" {
  description = "Port externe nginx"
  type        = number
  default     = 8086
}

variable "server_names" {
  description = "Liste des noms des serveurs"
  type        = list(string)
  default     = ["Alan", "Augustin", "Hugo"]
}