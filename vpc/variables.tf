variable "aws_region" {
  description = "デプロイするAWSリージョン"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "リソースに付与するプロジェクト名タグ"
  type        = string
  default     = "noriki-me"
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
  default     = "10.192.0.0/16"
}

variable "subnet_newbits" {
  description = "VPCのCIDRプレフィックスに追加するビット数（サブネットマスクを決定）"
  type        = number
  default     = 9
}
variable "subnet_newbits_v6" {
  description = "VPCのCIDRプレフィックスに追加するビット数（サブネットマスクを決定）"
  type        = number
  default     = 8
}

variable "availability_zones" {
  description = "サブネットを作成するアベイラビリティゾーンのリスト"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "bastion_ssh_cidr" {
  description = "The CIDR block allowed to SSH into the Bastion instance."
  type        = list(string)
  default     = ["126.95.107.164/32"]
}

variable "bastion_az" {
  type        = string
  description = "Availability Zone for the Bastion instance."
  default     = "us-west-2b"
}

variable "bastion_ssh_ipv6_cidr" {
  type        = list(string)
  description = "IPv6 CIDR blocks for Bastion SSH access."
  default     = ["2400:2651:8a1:b00::/64"]
}