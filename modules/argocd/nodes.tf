module "nodes" {
  source              = "duplocloud/components/duplocloud//modules/eks-nodes"
  version             = "0.0.20"
  tenant_id           = local.tenant_id
  base_ami_name       = "amazon-eks-node"
  prefix              = "argo"
  encrypt_disk        = true
  capacity            = var.asg.capacity
  az_list             = var.asg.az_list
  instance_count      = var.asg.instance_count
  min_instance_count  = var.asg.min_instance_count
  max_instance_count  = var.asg.max_instance_count
  os_disk_size        = var.asg.os_disk_size
  can_scale_from_zero = true
  metadata = {
    "MetadataServiceOption" = "enabled_v2_only"
  }
  minion_tags = {
    AllocationTags = "argocd"
  }
}
