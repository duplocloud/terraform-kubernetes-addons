# locals {
#   external-dns = {
#     sa_name  = "external-dns-${local.context.workspace}"
#     sa_email = "external-dns-${local.context.workspace}@${var.gcp_project_id}.iam.gserviceaccount.com"
#     # sa_name = ""
#     # sa_email  = ""
#     # fed identity
#     # member = "principal://iam.googleapis.com/projects/${local.project_number}/locations/global/workloadIdentityPools/${var.gcp_project_id}.svc.id.goog/subject/ns/${local.context.project_name}/sa/external-dns-${local.context.workspace}"
#     # workload identity
#     member = "serviceAccount:${var.gcp_project_id}.svc.id.goog[${local.context.project_name}/external-dns-${local.context.workspace}]"
#   }
# }

# # workload identity
# resource "google_service_account" "external-dns" {
#   count        = var.external-dns.enabled ? 1 : 0
#   account_id   = local.external-dns.sa_name
#   project      = var.gcp_project_id
#   display_name = "External DNS for ${local.context.workspace}"
#   description  = <<EOF
# A service account for External DNS to manage DNS records in Google Cloud DNS for ${local.context.workspace}.
# EOF
# }

# # workload identity
# resource "google_service_account_iam_member" "external-dns" {
#   count              = var.external-dns.enabled ? 1 : 0
#   service_account_id = google_service_account.external-dns[0].name
#   member             = local.external-dns.member
#   role               = "roles/iam.workloadIdentityUser"
# }

# # both
# resource "google_project_iam_member" "external-dns" {
#   count   = var.external-dns.enabled ? 1 : 0
#   project = var.gcp_project_id
#   role    = "roles/dns.reader"
#   # member  = local.external-dns.member
#   member = "serviceAccount:${local.external-dns.sa_email}"
#   depends_on = [
#     google_service_account.external-dns
#   ]
# }

# # I think both
# resource "google_dns_managed_zone_iam_member" "external-dns" {
#   count        = var.external-dns.enabled ? 1 : 0
#   project      = var.gcp_project_id
#   managed_zone = var.managed_zone_name
#   role         = "roles/dns.admin"
#   member       = "serviceAccount:${local.external-dns.sa_email}"
#   # member       = local.external-dns.member
#   depends_on = [
#     google_service_account.external-dns
#   ]
# }

# resource "kubernetes_manifest" "external-dns" {
#   count = var.external-dns.enabled ? 1 : 0
#   manifest = yamldecode(templatefile(
#     "${path.module}/project/external-dns.yaml",
#     merge(local.context, local.external-dns, var.external-dns)
#   ))
#   field_manager {
#     force_conflicts = true
#   }
#   depends_on = [
#     kubernetes_manifest.project
#   ]
# }
