variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "The domain name for the Route 53 hosted zone"
  type        = string
}

variable "comment" {
  description = "Comment for the hosted zone"
  type        = string
  default     = "Domain hosted zone"
}
