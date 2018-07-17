//--------------------------------------------------------------------
// Variables
variable "aws_account_email" {}

variable "aws_account_name" {}

variable "keybase_user" {}

//--------------------------------------------------------------------
// Modules
module "accounts" {
  source  = "app.terraform.io/Darnold-AWS-SubAccounts/accounts/aws"
  version = "3.0.6"

  aws_account_email = "${var.aws_account_email}"
  aws_account_name  = "${var.aws_account_name}"
  keybase_user      = "${var.keybase_user}"
}

output "role_name" {
  value = "${module.accounts.role_name}"
}

output "account_id" {
  value = "${module.accounts.account_id}"
}

output "account_arn" {
  value = "${module.accounts.account_arn}"
}

output "vault_ec2_ro_path" {
  value = "aws-${var.aws_account_name}/creds/ec2_ro"
}

output "vault_ec2_admin_path" {
  value = "aws-${var.aws_account_name}/creds/ec2_admin"
}

output "vault_ec2_admin_policy" {
  value = "aws-${var.aws_account_name}-admin"
}

output "vault_ec2_ro_policy" {
  value = "aws-${var.aws_account_name}-ro"
}

output "console_user" {
  value = "${module.accounts.console_user}"
}

output "console_password" {
  value = "${module.accounts.console_password}"
}
