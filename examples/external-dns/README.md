# Example External DNS Installation
External DNS watches Kubernetes ingress and load-balancer services and automatically manages DNS for them.

## Providers
You will need to configure:
* helm - for the chart deployment
* duplocloud - for datasources
* aws - for IAM role extension

## Helm Chart Usage
Please review the documentation for the Bitnami chart and external-dns:
https://github.com/kubernetes-sigs/external-dns
https://github.com/bitnami/charts/tree/main/bitnami/external-dns


## Notes
The default tenant role does not include permissions to manage DNS records as this is typically managed entirely by Duplocloud.  ExternalDNS requires an extension of the tenant role to manage Route53 records and view zones.


