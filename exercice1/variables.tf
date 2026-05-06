variable "instance_type" {
  description = "Type EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Nom de l'instance EC2"
  type        = string
  default     = "nginx-server-ex1"
}

variable "bucket_name" {
  description = "Nom du bucket S3"
  type        = string
  default     = "my-bucket-exercice1"
}

variable "sg_port" {
  description = "Port du security group"
  type        = number
  default     = 80
}

variable "key_name" {
  description = "Nom de la key pair"
  type        = string
  default     = "deployer-key-ex1"
}

variable "security_group_name" {
  description = "Nom du security group"
  type        = string
  default     = "nginx-sg-ex1"
}