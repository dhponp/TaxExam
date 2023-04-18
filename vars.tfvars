variable "port" {
  type    = number
  default = 8080
}

variable "namespace" {
  type    = string
  default = "exam"
}

variable "containers_ports" {
  type = object({
    port = number
	node_port = number
    target_port = number
  })
  default = (
    {
      port = 8080
	  node_port = 30201
      target_port = 80
    })
}