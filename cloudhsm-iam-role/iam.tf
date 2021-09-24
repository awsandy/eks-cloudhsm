data "aws_iam_policy_document" "cloudhsm_serviceaccount_assume" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]
    
    principals {
      type = "Federated"
      identifiers = [
          "arn:aws:iam::566972129213:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/A648AC06C6D3361510EDAD12C9408957"
      ]
    }
  }
}

data "aws_iam_policy_document" "cloudhsm_serviceaccount_document" {
  statement {
    sid    = "keystore"
    effect = "Allow"
    actions = [ "*",]
    resources = ["*"]
  }
}

resource "aws_iam_role" "cloudhsm_serviceaccount_role" {
  name               =  "cloudhsm-svcacct-role"
  assume_role_policy = data.aws_iam_policy_document.cloudhsm_serviceaccount_assume.json


  lifecycle {
    ignore_changes = [
      tags["CreatedActor"]
    ]
  }
}

resource "aws_iam_role_policy" "cloudhsm_serviceaccount_policy" {
  name   = "cloudhsm-svc-acct-policy"
  role   = aws_iam_role.cloudhsm_serviceaccount_role.id
  policy = data.aws_iam_policy_document.cloudhsm_serviceaccount_document.json
}