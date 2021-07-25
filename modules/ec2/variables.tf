variable "namespace" {
  type = string
}

variable "vpc" {
  type = any
}

variable key_name {
  type = string
}

variable "sg_pub_id" {
  type = any
}

variable "root_volume_size" {
    default = 8 
}

variable "sg_priv_id" {
  type = any
}

variable "delete_on_termination" {
    default = true
}

variable "volume_size" {
    default = 20
}

variable "volume_type" {
    default = "gp2"
}