output "service_account_arn" {
  description = "The ARN of the service account used by the AWS ALB controller"
  value       = module.lb_role.iam_role_arn
}

/*output "helm_release_status" {
  description = "The status of the Helm release for the AWS ALB controller"
  value       = helm_release.lb.status
}
*/

