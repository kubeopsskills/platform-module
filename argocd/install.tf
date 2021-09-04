resource "kubectl_manifest" "argocd" {
  for_each           = fileset(path.module, "installation/${var.cloud_type}/*.yaml")
  yaml_body          = file(each.value)
  override_namespace = "argocd"
}