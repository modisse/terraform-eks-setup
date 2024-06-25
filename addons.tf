# EKS Addons
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn

  depends_on = [module.eks, module.irsa-ebs-csi]
}

output "ebs_csi_driver_addon_id" {
  description = "ID of the AWS EBS CSI Driver addon"
  value       = aws_eks_addon.ebs_csi_driver.id
}

output "ebs_csi_driver_addon_name" {
  description = "Name of the AWS EBS CSI Driver addon"
  value       = aws_eks_addon.ebs_csi_driver.addon_name
}
