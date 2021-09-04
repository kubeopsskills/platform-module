data "template_file" "levis_plugin_patch" {
  template = file("${path.module}/installation/${var.cloud_type}/plugin/deployment-patch.tpl")
  vars = {
    argocd_levis_plugin_container_image = var.argocd_levis_plugin_container_image
  }
  depends_on = [kubectl_manifest.argocd]
}

resource "kubectl_manifest" "argocd_levis_plugin" {
  yaml_body          = data.template_file.levis_plugin_patch.rendered
  override_namespace = "argocd"
}