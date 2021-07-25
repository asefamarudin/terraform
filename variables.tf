variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  default     = "gass"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "ap-southeast-1"
  type        = string
}