resource "aws_ssoadmin_permission_set" "dev" {
  instance_arn     = tolist(data.aws_ssoadmin_instances.sso_instance.arns)[0]
  name             = "Developer"
  description      = "Developer permission set"
  session_duration = "PT1H"
}

resource "aws_ssoadmin_permission_set" "cdk" {
  instance_arn     = tolist(data.aws_ssoadmin_instances.sso_instance.arns)[0]
  name             = "CDK"
  description      = "CDK permission set"
  session_duration = "PT1H"
}

resource "aws_ssoadmin_permission_set_inline_policy" "dev" {
  permission_set_arn = aws_ssoadmin_permission_set.dev.arn
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso_instance.arns)[0]
  inline_policy      = data.aws_iam_policy.dev.policy
}

resource "aws_ssoadmin_permission_set_inline_policy" "cdk" {
  permission_set_arn = aws_ssoadmin_permission_set.cdk.arn
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso_instance.arns)[0]
  inline_policy      = data.aws_iam_policy_document.cdk.json
}

data "aws_iam_policy_document" "cdk" {
    statement {
        actions = [
            "sts:AssumeRole",
        ]
        resources = [
            "arn:aws:iam::*:role/cdk-*"
        ]
        effect = "Allow"
    }
}

data "aws_iam_policy" "dev" {
    arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_ssoadmin_account_assignment" "Developer" {
  for_each   = aws_identitystore_group.group
  depends_on = [aws_identitystore_group_membership.group_membership]

  instance_arn       = tolist(data.aws_ssoadmin_instances.sso_instance.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.dev.arn

  principal_id   = each.value.group_id
  principal_type = "GROUP"
  target_id      = data.aws_caller_identity.current.account_id
  target_type    = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "cdk" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso_instance.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.cdk.arn

  principal_id   = aws_identitystore_group.group["CDK"].group_id
  principal_type = "GROUP"
  target_id      = data.aws_caller_identity.current.account_id
  target_type    = "AWS_ACCOUNT"
}

data "aws_caller_identity" "current" {}
