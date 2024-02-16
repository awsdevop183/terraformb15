resource "random_password" "mypass" {
  length           = 12
  special          = true
  override_special = "="
}

