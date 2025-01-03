variable "argocd" {
  type = object({
    namespace = string
  })
}

variable "cloudflare_api_token" {
  type        = string
  default     = "empty"
  sensitive = true
}

variable "cloudflare_domain" {
  type        = string
  default     = "empty"
  sensitive = true

}

variable "cloudflare_email" {
  type        = string
  default     = "empty"
  sensitive = true
}

variable "environment" {
  type = string
}
