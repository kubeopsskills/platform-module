resource "kubectl_manifest" "namespace" {
  yaml_body = file("${path.module}/namespace.yaml")
}
module "argocd" {
  source           = "git@github.com:kubeopsskills/kubernetes-module//helm"
  release_name     = "argo-cd"
  chart_repository = "https://argoproj.github.io/argo-helm"
  chart_name       = "argo-cd"
  chart_version    = "3.17.6"
  config_file_path = "${path.module}/installation/${var.cloud_type}/argocd.yaml"
  namespace        = "argocd"
  lint_enabled     = true
  depends_on       = [kubectl_manifest.namespace]
}