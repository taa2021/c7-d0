output "id" {
  description = "The cloud security group's ID"

  value = module.vpc-sg-self.id
}
