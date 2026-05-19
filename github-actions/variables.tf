variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "github_repo" {
  description = "GitHub repository to allow access (e.g. noriki-nakamura/noriki-me-aws)"
  type        = string
  default     = "noriki-nakamura/noriki-me-aws"
}
