locals {
  member_ids_group = {
    for user in var.users : "${user.fname}.${user.lname}" => {
      user_id = aws_identitystore_user.user["${user.fname}.${user.lname}"].user_id
      group_id = aws_identitystore_group.group[user.group_name].group_id
    }
  }
}

data "aws_ssoadmin_instances" "sso_instance" {}

resource "aws_identitystore_group" "group" {
  for_each          = toset(var.groups)
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso_instance.identity_store_ids)[0]
  display_name      = each.value
  description       = each.value
}

resource "aws_identitystore_user" "user" {
  for_each          = { for user in var.users : "${user.fname}.${user.lname}" => user }
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso_instance.identity_store_ids)[0]
  display_name      = "${each.value.fname}.${each.value.lname}"
  user_name         = "${each.value.fname}.${each.value.lname}"
  name {
    family_name = each.value.fname
    given_name  = each.value.lname
  }
}

resource "aws_identitystore_group_membership" "group_membership" {
  for_each = local.member_ids_group

  group_id = each.value.group_id
  member_id = each.value.user_id

  identity_store_id = tolist(data.aws_ssoadmin_instances.sso_instance.identity_store_ids)[0]
}
