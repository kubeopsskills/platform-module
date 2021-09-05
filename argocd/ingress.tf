data "template_file" "ingress" {
  template = file("${path.module}/installation/${var.cloud_type}/ingress/ingress.tpl")
  vars = {
    argocd_aws_certificate_arn = var.argocd_aws_certificate_arn
    argocd_aws_domain          = var.argocd_aws_domain
    argocd_aws_subnets         = var.argocd_aws_subnets
    argocd_aws_sg              = var.argocd_aws_sg
    argocd_aws_tags            = var.argocd_aws_tags
  }
  depends_on = [module.argocd]
}

resource "kubectl_manifest" "argocd_ingress" {
  yaml_body          = data.template_file.ingress.rendered
  override_namespace = "argocd"
}