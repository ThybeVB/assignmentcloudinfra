variable "cluster_name" {
  type = string
  default = "reminder-app-cluster"
}

variable "compartment_id" {
  type      = string
  sensitive = true
}

variable "region" {
  type = string
  default = "eu-amsterdam-1"
}

variable "availability_domain" {

}

variable kubernetes_version {
  type = string
  default = "v1.32"
}

variable "public_key" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "is_private" {
  type    = bool
  default = false
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "default_fault_domain" {
  default = "FAULT-DOMAIN-1"
}

variable "os_image_id" {
  type = string
}

variable "shape" {
  type = string
}

variable "memory_in_gbs" {
  default = "4"
}

variable "ocpus" {
  default = "1"
}