variable "bucket_state_name" {
  type        = string
  description = "Bucket state name"
}

variable "remote_state_key" {
  type        = string
  default     = "PROD/infrastructure.tfstate"
  description = "Infrastructure remote state key"
}

variable "ecs_cluster_name" {
  type        = string
  default     = "Production-ECS-Cluster"
  description = "ECS Cluster name"
}

variable "internet_cidr_blocks" {
  default     = "0.0.0.0/0"
  type        = string
  description = "Internet cidr blocks"
}

variable "ecs_domain_name" {
  default     = "awsdevbot.com"
  type        = string
  description = "ECS domain name"
}
