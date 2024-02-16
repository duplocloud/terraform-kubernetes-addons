# Example External DNS Installation
External DNS watches Kubernetes ingresses and load-balancer services and automatically manages DNS for them.

## Providers
You will need to configure:
* helm - for the chart deployment
* duplocloud - for datasources
* aws - for IAM role extension (AWS installs only)

## Helm Chart Usage
Please review the documentation for the Bitnami chart and external-dns:
https://github.com/kubernetes-sigs/external-dns
https://github.com/bitnami/charts/tree/main/bitnami/external-dns

## Notes
The default tenant role does not include permissions to manage DNS records because DNS is typically managed entirely by DuploCloud.  ExternalDNS requires an extension of the tenant role to manage Route53 records and view DNS zones.  The module will automatically attach the appropriate IAM policy to the tenant role unless it is passed a pre-configured `service_account` to use.  For instances where you're managing role extensions separately (usually to avoid policy attachment limits), you can pass the tenant IAM role manually to this module to skip attaching the policy.

The required IAM permissions are:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets",
        "route53:ListTagsForResource"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
```
NOTE: If managing policies elsewhere, you should update `arn:aws:route53:::hostedzone/*` in the sample policy to permit updates only to explicit Hosted Zone IDs.

