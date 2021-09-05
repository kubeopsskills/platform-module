resource "kubectl_manifest" "namespace" {
  yaml_body = file("${path.module}/namespace.yaml")
}

data "template_file" "argocd_template" {
  template = file("${path.module}/installation/${var.cloud_type}/argocd.tpl")
  vars = {
    argocd_levis_plugin_container_image = var.argocd_levis_plugin_container_image
    argocd_aws_certificate_arn          = var.argocd_aws_certificate_arn
    argocd_aws_domain                   = var.argocd_aws_domain
    argocd_aws_subnets                  = var.argocd_aws_subnets
    argocd_aws_sg                       = var.argocd_aws_sg
    argocd_aws_tags                     = var.argocd_aws_tags
  }
}

resource "helm_release" "argocd" {
  name        = "argo-cd"
  repository  = "https://argoproj.github.io/argo-helm"
  chart       = "argo-cd"
  version     = "3.17.6"
  namespace   = "argocd"
  lint        = true
  atomic      = true
  max_history = 10
  values = [
    data.template_file.argocd_template.rendered
  ]

  depends_on = [kubectl_manifest.namespace]
}