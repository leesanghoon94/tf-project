variable "env" {
 type = string
 default = "default"
}

variable "availability_zone" {
  type = list(string)
  default = [ "ap-northeast-2c" ]
}