variable "image_name" {
  description = "Image nginx"
  type        = string
  default     = "nginx:latest"
}

variable "container_name" {
  description = "Nom du conteneur nginx"
  type        = string
  default     = "nginx-terraform-ex4"
}

variable "internal_port" {
  description = "Port interne nginx"
  type        = number
  default     = 80
}

variable "external_port" {
  description = "Port externe"
  type        = number
  default     = 8084
}