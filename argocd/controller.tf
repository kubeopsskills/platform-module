resource "kubectl_manifest" "controller_patch" {
  yaml_body          = file("${path.module}/controller_patch.yaml")
  override_namespace = "argocd"
}