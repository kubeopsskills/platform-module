variable "cloud_type" {
  description = "Cloud Type"
  type        = string
}

variable "argocd_levis_plugin_container_image" {
  description = "Argocd Levis Plugin Container Image"
  type        = string
}

variable "argocd_aws_certificate_arn" {
  description = "Argocd AWS Certificate ARN"
  type        = string
}

variable "argocd_aws_domain" {
  description = "Argocd AWS Domain"
  type        = string
}

variable "argocd_aws_subnets" {
  description = "Argocd AWS Subnets"
  type        = string
}

variable "argocd_aws_sg" {
  description = "Argocd AWS Security Group"
  type        = string
}

variable "argocd_aws_tags" {
  description = "Argocd AWS Tags"
  type        = string
}