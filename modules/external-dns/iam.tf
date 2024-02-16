# Extension for AWS DuploCloud tenant role for R53 permissions
data "aws_iam_policy_document" "service_extension" {
  count = local.iam_extension
  statement {
    sid = "externaldns"
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = [
      var.route53_zone_arn
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
  source          = "github.com/duplocloud/terraform-duplocloud-components//modules/tenant-role-extension?ref=main"
  tenant_name     = var.tenant_name
  iam_policy_json = data.aws_iam_policy_document.service_extension[0].json
}
