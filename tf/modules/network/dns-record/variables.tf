variable "zone-id" {
  description = "The cloud dns zone's ID"

  type = string
}

variable "name" {
  description = "The DNS name this record set will apply to."

  type = string
}

variable "type" {
  description = "The DNS record set type."

  type = string
}

variable "data" {
  description = "The string data for the records in this record set."

  type = set(string)
}
