# Extension for AWS DuploCloud tenant role for R53 permissions
data "aws_iam_policy_document" "service_extension" {
  count = local.iam_extension
  statement {
    sid = "externaldns"
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = [
      data.aws_route53_zone.this[0].arn
    ]
  }
  statement {
    sid = "externaldnsglobal"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource"
    ]
    resources = ["*"]
  }
}

module "tenant-role" {
  count           = local.iam_extension
  source          = "github.com/duplocloud/terraform-duplocloud-components//modules/tenant-role-extension?ref=v0.0.14"
  tenant_name     = var.tenant_name
  iam_policy_json = data.aws_iam_policy_document.service_extension[0].json
}
