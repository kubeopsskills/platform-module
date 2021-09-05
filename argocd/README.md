## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.11.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.3.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.11.3 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.argocd_levis_plugin](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.controller_patch](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.namespace](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [template_file.argocd_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.levis_plugin_patch](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_aws_certificate_arn"></a> [argocd\_aws\_certificate\_arn](#input\_argocd\_aws\_certificate\_arn) | Argocd AWS Certificate ARN | `string` | n/a | yes |
| <a name="input_argocd_aws_domain"></a> [argocd\_aws\_domain](#input\_argocd\_aws\_domain) | Argocd AWS Domain | `string` | n/a | yes |
| <a name="input_argocd_aws_sg"></a> [argocd\_aws\_sg](#input\_argocd\_aws\_sg) | Argocd AWS Security Group | `string` | n/a | yes |
| <a name="input_argocd_aws_subnets"></a> [argocd\_aws\_subnets](#input\_argocd\_aws\_subnets) | Argocd AWS Subnets | `string` | n/a | yes |
| <a name="input_argocd_aws_tags"></a> [argocd\_aws\_tags](#input\_argocd\_aws\_tags) | Argocd AWS Tags | `string` | n/a | yes |
| <a name="input_argocd_levis_plugin_container_image"></a> [argocd\_levis\_plugin\_container\_image](#input\_argocd\_levis\_plugin\_container\_image) | Argocd Levis Plugin Container Image | `string` | n/a | yes |
| <a name="input_cloud_type"></a> [cloud\_type](#input\_cloud\_type) | Cloud Type | `string` | n/a | yes |

## Outputs

No outputs.
