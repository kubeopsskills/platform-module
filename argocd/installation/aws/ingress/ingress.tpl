apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: argocd
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/certificate-arn: ${argocd_aws_certificate_arn}
    alb.ingress.kubernetes.io/success-codes: 200-399
    alb.ingress.kubernetes.io/backend-protocol: HTTPS
    alb.ingress.kubernetes.io/conditions.argogrpc: |
        [{"field":"http-header","httpHeaderConfig":{"httpHeaderName": "Content-Type", "values":["application/grpc"]}}]
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/security-groups: ${argocd_aws_sg}
    alb.ingress.kubernetes.io/subnets: ${argocd_aws_subnets}
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: '10'
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: '5'
    alb.ingress.kubernetes.io/healthy-threshold-count: '2'
    alb.ingress.kubernetes.io/unhealthy-threshold-count: '3'
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/tags: ${argocd_aws_tags}
spec:
  rules:
  - host: ${argocd_aws_domain}
    http:
      paths:
      - backend:
          serviceName: argogrpc
          servicePort: 443
        path: /*
      - backend:
          serviceName: argocd-server
          servicePort: 443
        path: /*