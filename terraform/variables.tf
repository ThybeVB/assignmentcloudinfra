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
  default = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaaxx563fxzlxnu2kpgsq66okj7hb6qprhof2xwggcl54erovurlxxq"
}

variable "shape" {
  default = "VM.Standard.A1.Flex"
}

variable "memory_in_gbs" {
  default = "4"
}

variable "ocpus" {
  default = "1"
}