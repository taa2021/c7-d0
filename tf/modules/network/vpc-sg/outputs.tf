output "id" {
  description = "The cloud security group's ID"

  value = yandex_vpc_security_group.vpc-sg.id
}
