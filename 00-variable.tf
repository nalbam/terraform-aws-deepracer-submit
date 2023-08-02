# variable

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  type    = string
  default = "dr-submit"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "market_type" {
  type    = string
  default = "spot"
}

variable "ami_id" {
  type    = string
  default = ""
}

variable "ebs_optimized" {
  type    = bool
  default = true
}

variable "volume_type" {
  type    = string
  default = "gp3"
}

variable "volume_size" {
  type    = string
  default = "30"
}

variable "iops" {
  type    = string
  default = "3000"
}

variable "throughput" {
  type    = string
  default = "125"
}

variable "delete_on_termination" {
  type    = bool
  default = true
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}

variable "min" {
  type    = number
  default = 0
}

variable "max" {
  type    = number
  default = 1
}

variable "desired" {
  type    = number
  default = 0
}

# variable "suspended_processes" {
#   type = list(string)
#   default = [
#     # "Launch",
#   ]
# }

variable "on_demand_base" {
  type    = number
  default = 0
}

variable "on_demand_rate" {
  type    = number
  default = 0
}

variable "spot_strategy" {
  type    = string
  default = "capacity-optimized"
  # lowest-price, capacity-optimized, capacity-optimized-prioritized, price-capacity-optimized
}

variable "allow_ip_address" {
  type = list(string)
  default = [
    "0.0.0.0/0",
    # "39.117.14.79/32", # echo "$(curl -sL icanhazip.com)/32"
  ]
}

variable "key_name" {
  type    = string
  default = "nalbam-seoul"
}

variable "zone_name" {
  type    = string
  default = ""
}
