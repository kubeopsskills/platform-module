## ArgoCD configuration
## Ref: https://github.com/argoproj/argo-cd
##
nameOverride: argocd
fullnameOverride: ""
kubeVersionOverride: ""

global:
  image:
    repository: quay.io/argoproj/argocd
    tag: v2.1.2
    imagePullPolicy: IfNotPresent
  ## Annotations applied to all pods
  podAnnotations: {}
  ## Labels applied to all pods
  podLabels: {}
  securityContext: {}
  #  runAsUser: 999
  #  runAsGroup: 999
  #  fsGroup: 999
  imagePullSecrets: []
  hostAliases: []
  # - ip: 10.20.30.40
  #   hostnames:
  #   - git.myhostname

  networkPolicy:
    create: true
    defaultDenyIngress: false

# Override APIVersions
# If you want to template helm charts but cannot access k8s API server
# you can set api versions here
apiVersionOverrides:
  certmanager: "" # cert-manager.io/v1
  ingress: "" # networking.k8s.io/v1beta1

## Create clusterroles that extend existing clusterroles to interact with argo-cd crds
## Ref: https://kubernetes.io/docs/reference/access-authn-authz/rbac/#aggregated-clusterroles
createAggregateRoles: false

## Controller
controller:
  name: application-controller

  image:
    repository: # defaults to global.image.repository
    tag: # defaults to global.image.tag
    imagePullPolicy: # IfNotPresent

  # If changing the number of replicas you must pass the number as ARGOCD_CONTROLLER_REPLICAS as an environment variable
  replicas: 1

  # Deploy the application as a StatefulSet instead of a Deployment, this is required for HA capability.
  # This is a feature flag that will become the default in chart version 3.x
  enableStatefulSet: false

  ## Argo controller commandline flags
  args:
    statusProcessors: "20"
    operationProcessors: "10"
    appResyncPeriod: "180"
    selfHealTimeout: "5"
    repoServerTimeoutSeconds: "60"

  ## Argo controller log format: text|json
  logFormat: text
  ## Argo controller log level
  logLevel: info

  ## Additional command line arguments to pass to argocd-controller
  ##
  extraArgs: []

  ## Environment variables to pass to argocd-controller
  ##
  env:
    []
    # - name: "ARGOCD_CONTROLLER_REPLICAS"
    #   value: ""

  ## envFrom to pass to argocd-controller
  ##
  envFrom: []
  # - configMapRef:
  #     name: config-map-name
  # - secretRef:
  #     name: secret-name

  ## Annotations to be added to controller pods
  ##
  podAnnotations: {}

  ## Labels to be added to controller pods
  ##
  podLabels: {}

  ## Labels to set container specific security contexts
  containerSecurityContext:
    {}
    # capabilities:
    #   drop:
    #     - all
    # readOnlyRootFilesystem: true
    # runAsNonRoot: true

  ## Configures the controller port
  containerPort: 8082

  ## Readiness and liveness probes for default backend
  ## Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
  ##
  readinessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  livenessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1

  ## Additional volumeMounts to the controller main container.
  volumeMounts: []

  ## Additional volumes to the controller pod.
  volumes: []

  ## Controller service configuration
  service:
    annotations: {}
    labels: {}
    port: 8082
    portName: https-controller

  ## Node selectors and tolerations for server scheduling to nodes with taints
  ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
  ##
  nodeSelector: {}
  tolerations: []
  affinity: {}

  priorityClassName: ""

  resources: {}
  #  limits:
  #    cpu: 500m
  #    memory: 512Mi
  #  requests:
  #    cpu: 250m
  #    memory: 256Mi

  serviceAccount:
    create: true
    name: argocd-application-controller
    ## Annotations applied to created service account
    annotations: {}
    ## Automount API credentials for the Service Account
    automountServiceAccountToken: true

  ## Server metrics controller configuration
  metrics:
    enabled: false
    service:
      annotations: {}
      labels: {}
      servicePort: 8082
    serviceMonitor:
      enabled: false
      interval: 30s
      relabelings: []
      metricRelabelings: []
    #   selector:
    #     prometheus: kube-prometheus
    #   namespace: monitoring
    #   additionalLabels: {}
    rules:
      enabled: false
      spec: []
      # - alert: ArgoAppMissing
      #   expr: |
      #     absent(argocd_app_info)
      #   for: 15m
      #   labels:
      #     severity: critical
      #   annotations:
      #     summary: "[ArgoCD] No reported applications"
      #     description: >
      #       ArgoCD has not reported any applications data for the past 15 minutes which
      #       means that it must be down or not functioning properly.  This needs to be
      #       resolved for this cloud to continue to maintain state.
      # - alert: ArgoAppNotSynced
      #   expr: |
      #     argocd_app_info{sync_status!="Synced"} == 1
      #   for: 12h
      #   labels:
      #     severity: warning
      #   annotations:
      #     summary: "[{{`{{$labels.name}}`}}] Application not synchronized"
      #     description: >
      #       The application [{{`{{$labels.name}}`}} has not been synchronized for over
      #       12 hours which means that the state of this cloud has drifted away from the
      #       state inside Git.
    #   selector:
    #     prometheus: kube-prometheus
    #   namespace: monitoring
    #   additionalLabels: {}

  ## Enable Admin ClusterRole resources.
  ## Enable if you would like to grant rights to ArgoCD to deploy to the local Kubernetes cluster.
  clusterAdminAccess:
    enabled: true
  ## Enable Custom Rules for the Application Controller's Cluster Role resource
  ## Enable this and set the rules: to whatever custom rules you want for the Cluster Role resource.
  ## Defaults to off
  clusterRoleRules:
    enabled: false
    rules: []


## Dex
dex:
  enabled: true
  name: dex-server

  metrics:
    enabled: false
    service:
      annotations: {}
      labels: {}
    serviceMonitor:
      enabled: false
      interval: 30s
      relabelings: []
      metricRelabelings: []
      # selector:
      #   prometheus: kube-prometheus
      # namespace: monitoring
      # additionalLabels: {}

  image:
    repository: ghcr.io/dexidp/dex
    tag: v2.30.0
    imagePullPolicy: IfNotPresent
  initImage:
    repository:
    tag:
    imagePullPolicy:

  ## Environment variables to pass to the Dex server
  ##
  env: []

  ## envFrom to pass to the Dex server
  envFrom: []
  # - configMapRef:
  #     name: config-map-name
  # - secretRef:
  #     name: secret-name

  ## Annotations to be added to the Dex server pods
  ##
  podAnnotations: {}

  ## Labels to be added to the Dex server pods
  ##
  podLabels: {}

  ## Probes for Dex server
  ## Supported from Dex >= 2.28.0
  livenessProbe:
    enabled: false
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  readinessProbe:
    enabled: false
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1

  serviceAccount:
    create: true
    name: argocd-dex-server
    ## Annotations applied to created service account
    annotations: {}
    ## Automount API credentials for the Service Account
    automountServiceAccountToken: true

  ## Additional volumeMounts to the controller main container.
  volumeMounts:
    - name: static-files
      mountPath: /shared

  ## Additional volumes to the controller pod.
  volumes:
    - name: static-files
      emptyDir: {}

  ## Dex deployment container ports
  containerPortHttp: 5556
  servicePortHttp: 5556
  servicePortHttpName: http
  containerPortGrpc: 5557
  servicePortGrpc: 5557
  servicePortGrpcName: grpc
  containerPortMetrics: 5558
  servicePortMetrics: 5558

  ## Node selectors and tolerations for server scheduling to nodes with taints
  ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
  ##
  nodeSelector: {}
  tolerations: []
  affinity: {}

  priorityClassName: ""

  ## Labels to set container specific security contexts
  containerSecurityContext:
    {}
    # capabilities:
    #   drop:
    #     - all
    # readOnlyRootFilesystem: true

  resources: {}
  #  limits:
  #    cpu: 50m
  #    memory: 64Mi
  #  requests:
  #    cpu: 10m
  #    memory: 32Mi

## Redis
redis:
  enabled: true
  name: redis

  image:
    repository: redis
    tag: 6.2.4-alpine
    imagePullPolicy: IfNotPresent

  ## Additional command line arguments to pass to redis-server
  ##
  extraArgs: []
  # - --bind
  # - "0.0.0.0"

  containerPort: 6379
  servicePort: 6379

  ## Environment variables to pass to the Redis server
  ##
  env: []

  ## envFrom to pass to the Redis server
  ##
  envFrom: []
  # - configMapRef:
  #     name: config-map-name
  # - secretRef:
  #     name: secret-name

  ## Annotations to be added to the Redis server pods
  ##
  podAnnotations: {}

  ## Labels to be added to the Redis server pods
  ##
  podLabels: {}

  ## Node selectors and tolerations for server scheduling to nodes with taints
  ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
  ##
  nodeSelector: {}
  tolerations: []
  affinity: {}

  priorityClassName: ""

  ## Labels to set container specific security contexts
  containerSecurityContext:
    {}
    # capabilities:
    #   drop:
    #     - all
    # readOnlyRootFilesystem: true

  ## Redis Pod specific security context
  securityContext:
    runAsNonRoot: true
    runAsUser: 999

  serviceAccount:
    create: false
    name: ""
    ## Annotations applied to created service account
    annotations: {}
    ## Automount API credentials for the Service Account
    automountServiceAccountToken: false

  resources: {}
  #  limits:
  #    cpu: 200m
  #    memory: 128Mi
  #  requests:
  #    cpu: 100m
  #    memory: 64Mi

  volumeMounts: []
  volumes: []

# This key configures Redis-HA subchart and when enabled (redis-ha.enabled=true)
# the custom redis deployment is omitted
redis-ha:
  enabled: false
  # Check the redis-ha chart for more properties
  exporter:
    enabled: true
  persistentVolume:
    enabled: false
  redis:
    masterGroupName: argocd
    config:
      save: '""'
  haproxy:
    enabled: true
    metrics:
      enabled: true
  image:
    tag: 6.2.4-alpine

## Server
server:
  name: server

  replicas: 1

  autoscaling:
    enabled: false
    minReplicas: 1
    maxReplicas: 5
    targetCPUUtilizationPercentage: 50
    targetMemoryUtilizationPercentage: 50

  image:
    repository: # defaults to global.image.repository
    tag: # defaults to global.image.tag
    imagePullPolicy: # IfNotPresent

  ## Additional command line arguments to pass to argocd-server
  ##
  extraArgs: []
  #  - --insecure

  # This flag is used to either remove or pass the CLI flag --staticassets /shared/app to the argocd-server app
  staticAssets:
    enabled: true

  ## Environment variables to pass to argocd-server
  ##
  env: []

  ## envFrom to pass to argocd-server
  ##
  envFrom: []
  # - configMapRef:
  #     name: config-map-name
  # - secretRef:
  #     name: secret-name

  ## Specify postStart and preStop lifecycle hooks for your argo-cd-server container
  ##
  lifecycle: {}

  ## Argo server log format: text|json
  logFormat: text
  ## Argo server log level
  logLevel: info

  ## Annotations to be added to controller pods
  ##
  podAnnotations: {}

  ## Labels to be added to controller pods
  ##
  podLabels: {}

  ## Configures the server port
  containerPort: 8080

  ## Readiness and liveness probes for default backend
  ## Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
  ##
  readinessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  livenessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1

  ## Additional volumeMounts to the server main container.
  volumeMounts: []

  ## Additional volumes to the controller pod.
  volumes: []

  ## Node selectors and tolerations for server scheduling to nodes with taints
  ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
  ##
  nodeSelector: {}
  tolerations: []
  affinity: {}

  priorityClassName: ""

  ## Labels to set container specific security contexts
  containerSecurityContext:
    {}
    # capabilities:
    #   drop:
    #     - all
    # readOnlyRootFilesystem: true

  resources: {}
  #  limits:
  #    cpu: 100m
  #    memory: 128Mi
  #  requests:
  #    cpu: 50m
  #    memory: 64Mi

  ## Certificate configuration
  certificate:
    enabled: false
    domain: argocd.example.com
    issuer:
      kind: # ClusterIssuer
      name: # letsencrypt
    additionalHosts: []
    secretName: argocd-server-tls

  ## Server service configuration
  service:
    annotations: {}
    labels: {}
    type: ClusterIP
    ## For node port default ports
    nodePortHttp: 30080
    nodePortHttps: 30443
    servicePortHttp: 80
    servicePortHttps: 443
    servicePortHttpName: http
    servicePortHttpsName: https
    namedTargetPort: true
    loadBalancerIP: ""
    loadBalancerSourceRanges: []
    externalIPs: []
    externalTrafficPolicy: ""
    sessionAffinity: ""

  ## Server metrics service configuration
  metrics:
    enabled: false
    service:
      annotations: {}
      labels: {}
      servicePort: 8083
    serviceMonitor:
      enabled: false
      interval: 30s
      relabelings: []
      metricRelabelings: []
    #   selector:
    #     prometheus: kube-prometheus
    #   namespace: monitoring
    #   additionalLabels: {}

  serviceAccount:
    create: true
    name: argocd-server
    ## Annotations applied to created service account
    annotations: {}
    ## Automount API credentials for the Service Account
    automountServiceAccountToken: true

  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: "alb"
      alb.ingress.kubernetes.io/certificate-arn: ${argocd_aws_certificate_arn}
      alb.ingress.kubernetes.io/success-codes: 200-399
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
    labels: {}
    ingressClassName: ""

    ## Argo Ingress.
    ## Hostnames must be provided if Ingress is enabled.
    ## Secrets must be manually created in the namespace
    ##
    hosts:
      - ${argocd_aws_domain}
      # - argocd.example.com
    paths:
      - /
    pathType: Prefix
    extraPaths:
      []
      # - path: /*
      #   backend:
      #     serviceName: ssl-redirect
      #     servicePort: use-annotation
      ## for Kubernetes >=1.19 (when "networking.k8s.io/v1" is used)
      # - path: /*
      #   pathType: Prefix
      #   backend:
      #     service:
      #       name: ssl-redirect
      #       port:
      #         name: use-annotation
    tls:
      []
      # - secretName: argocd-tls-certificate
      #   hosts:
      #     - argocd.example.com
    https: false
  # dedicated ingress for gRPC as documented at
  # https://argoproj.github.io/argo-cd/operator-manual/ingress/
  ingressGrpc:
    enabled: true
    isAWSALB: true
    annotations: 
      kubernetes.io/ingress.class: "alb"
      alb.ingress.kubernetes.io/certificate-arn: ${argocd_aws_certificate_arn}
      alb.ingress.kubernetes.io/success-codes: 200-399
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
    labels: {}
    ingressClassName: ""
    awsALB:
      ## Service Type if isAWSALB is set to true
      ## Can be of type NodePort or ClusterIP depending on which mode you are
      ## are running. Instance mode needs type NodePort, IP mode needs type
      ## ClusterIP
      ## Ref: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/how-it-works/#ingress-traffic
      serviceType: ClusterIP
      # This tells AWS to send traffic from the ALB using HTTP2. Can use GRPC as well if you want to leverage GRPC specific features
      backendProtocolVersion: HTTP2

    ## Argo Ingress.
    ## Hostnames must be provided if Ingress is enabled.
    ## Secrets must be manually created in the namespace
    ##
    hosts:
      - ${argocd_aws_domain}
    paths:
      - /
    pathType: Prefix
    extraPaths:
      []
      # - path: /*
      #   backend:
      #     serviceName: ssl-redirect
      #     servicePort: use-annotation
      ## for Kubernetes >=1.19 (when "networking.k8s.io/v1" is used)
      # - path: /*
      #   pathType: Prefix
      #   backend:
      #     service:
      #       name: ssl-redirect
      #       port:
      #         name: use-annotation
    tls:
      []
      # - secretName: argocd-tls-certificate
      #   hosts:
      #     - argocd.example.com
    https: false

  # Create a OpenShift Route with SSL passthrough for UI and CLI
  # Consider setting 'hostname' e.g. https://argocd.apps-crc.testing/ using your Default Ingress Controller Domain
  # Find your domain with: kubectl describe --namespace=openshift-ingress-operator ingresscontroller/default | grep Domain:
  # If 'hostname' is an empty string "" OpenShift will create a hostname for you.
  route:
    enabled: false
    hostname: ""

  ## ArgoCD config
  ## reference https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/argocd-cm.yaml
  configEnabled: true
  config:
    # Argo CD's externally facing base URL (optional). Required when configuring SSO
    url: https://argocd.example.com
    # Argo CD instance label key
    application.instanceLabelKey: argocd.argoproj.io/instance

    # DEPRECATED: Please instead use configs.credentialTemplates and configs.repositories
    # repositories: |
    #   - url: git@github.com:group/repo.git
    #     sshPrivateKeySecret:
    #       name: secret-name
    #       key: sshPrivateKey
    #   - type: helm
    #     url: https://charts.helm.sh/stable
    #     name: stable
    #   - type: helm
    #     url: https://argoproj.github.io/argo-helm
    #     name: argo

    # oidc.config: |
    #   name: AzureAD
    #   issuer: https://login.microsoftonline.com/TENANT_ID/v2.0
    #   clientID: CLIENT_ID
    #   clientSecret: $oidc.azuread.clientSecret
    #   requestedIDTokenClaims:
    #     groups:
    #       essential: true
    #   requestedScopes:
    #     - openid
    #     - profile
    #     - email

  ## Annotations to be added to ArgoCD ConfigMap
  configAnnotations: {}

  ## ArgoCD rbac config
  ## reference https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/rbac.md
  rbacConfig:
    {}
    # policy.csv is an file containing user-defined RBAC policies and role definitions (optional).
    # Policy rules are in the form:
    #   p, subject, resource, action, object, effect
    # Role definitions and bindings are in the form:
    #   g, subject, inherited-subject
    # See https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/rbac.md for additional information.
    # policy.csv: |
    #   # Grant all members of the group 'my-org:team-alpha; the ability to sync apps in 'my-project'
    #   p, my-org:team-alpha, applications, sync, my-project/*, allow
    #   # Grant all members of 'my-org:team-beta' admins
    #   g, my-org:team-beta, role:admin
    # policy.default is the name of the default role which Argo CD will falls back to, when
    # authorizing API requests (optional). If omitted or empty, users may be still be able to login,
    # but will see no apps, projects, etc...
    # policy.default: role:readonly
    # scopes controls which OIDC scopes to examine during rbac enforcement (in addition to `sub` scope).
    # If omitted, defaults to: '[groups]'. The scope value can be a string, or a list of strings.
    # scopes: '[cognito:groups, email]'

  ## Annotations to be added to ArgoCD rbac ConfigMap
  rbacConfigAnnotations: {}

  # Boolean determining whether or not to create the configmap. If false, it is expected the configmap will be created
  # by something else. ArgoCD will not work if there is no configMap created with the name above.
  rbacConfigCreate: true

  ## Not well tested and not well supported on release v1.0.0.
  ## Applications
  ## reference: https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/
  additionalApplications: []
  # - name: guestbook
  #   namespace: argocd
  #   additionalLabels: {}
  #   additionalAnnotations: {}
  #   project: guestbook
  #   source:
  #     repoURL: https://github.com/argoproj/argocd-example-apps.git
  #     targetRevision: HEAD
  #     path: guestbook
  #     directory:
  #       recurse: true
  #  destination:
  #     server: https://kubernetes.default.svc
  #     namespace: guestbook
  #  syncPolicy:
  #    automated:
  #      prune: false
  #      selfHeal: false

  ## Projects
  ## reference: https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/
  additionalProjects: []
  # - name: guestbook
  #   namespace: argocd
  #   additionalLabels: {}
  #   additionalAnnotations: {}
  #   description: Example Project
  #   sourceRepos:
  #   - '*'
  #   destinations:
  #   - namespace: guestbook
  #     server: https://kubernetes.default.svc
  #   clusterResourceWhitelist: []
  #   namespaceResourceBlacklist:
  #   - group: ''
  #     kind: ResourceQuota
  #   - group: ''
  #     kind: LimitRange
  #   - group: ''
  #     kind: NetworkPolicy
  #     orphanedResources: {}
  #     roles: []
  #   namespaceResourceWhitelist:
  #   - group: 'apps'
  #     kind: Deployment
  #   - group: 'apps'
  #     kind: StatefulSet
  #   orphanedResources: {}
  #   roles: []
  #   syncWindows:
  #   - kind: allow
  #     schedule: '10 1 * * *'
  #     duration: 1h
  #     applications:
  #     - '*-prod'
  #     manualSync: true

  ## Enable Admin ClusterRole resources.
  ## Enable if you would like to grant rights to ArgoCD to deploy to the local Kubernetes cluster.
  clusterAdminAccess:
    enabled: true

  ## Enable BackendConfig custom resource for Google Kubernetes Engine
  GKEbackendConfig:
    enabled: false
    spec: {}
  #  spec:
  #    iap:
  #      enabled: true
  #      oauthclientCredentials:
  #        secretName: argocd-secret

  extraContainers: []
  ## Additional containers to be added to the controller pod.
  ## See https://github.com/lemonldap-ng-controller/lemonldap-ng-controller as example.
  # - name: my-sidecar
  #   image: nginx:latest
  # - name: lemonldap-ng-controller
  #   image: lemonldapng/lemonldap-ng-controller:0.2.0
  #   args:
  #     - /lemonldap-ng-controller
  #     - --alsologtostderr
  #     - --configmap=$(POD_NAMESPACE)/lemonldap-ng-configuration
  #   env:
  #     - name: POD_NAME
  #       valueFrom:
  #         fieldRef:
  #           fieldPath: metadata.name
  #     - name: POD_NAMESPACE
  #       valueFrom:
  #         fieldRef:
  #           fieldPath: metadata.namespace
  #   volumeMounts:
  #   - name: copy-portal-skins
  #     mountPath: /srv/var/lib/lemonldap-ng/portal/skins

## Repo Server
repoServer:
  name: repo-server

  replicas: 1

  autoscaling:
    enabled: false
    minReplicas: 1
    maxReplicas: 5
    targetCPUUtilizationPercentage: 50
    targetMemoryUtilizationPercentage: 50

  image:
    repository: # defaults to global.image.repository
    tag: # defaults to global.image.tag
    imagePullPolicy: # IfNotPresent

  ## Additional command line arguments to pass to argocd-repo-server
  ##
  extraArgs: []

  ## Environment variables to pass to argocd-repo-server
  ##
  env: []

  ## envFrom to pass to argocd-repo-server
  ##
  envFrom: []
  # - configMapRef:
  #     name: config-map-name
  # - secretRef:
  #     name: secret-name

  ## Argo repoServer log format: text|json
  logFormat: text
  ## Argo repoServer log level
  logLevel: info

  ## Annotations to be added to repo server pods
  ##
  podAnnotations: {}

  ## Labels to be added to repo server pods
  ##
  podLabels: {}

  ## Configures the repo server port
  containerPort: 8081

  ## Readiness and liveness probes for default backend
  ## Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
  ##
  readinessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  livenessProbe:
    failureThreshold: 3
    initialDelaySeconds: 10
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1

  ## Additional volumeMounts to the repo server main container.
  volumeMounts: []

  ## Additional volumes to the repo server pod.
  volumes: []

  ## Node selectors and tolerations for server scheduling to nodes with taints
  ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
  ##
  nodeSelector: {}
  tolerations: []
  affinity: {}

  priorityClassName: ""

  ## Labels to set container specific security contexts
  containerSecurityContext:
    {}
    # capabilities:
    #   drop:
    #     - all
    # readOnlyRootFilesystem: true

  resources: {}
  #  limits:
  #    cpu: 50m
  #    memory: 128Mi
  #  requests:
  #    cpu: 10m
  #    memory: 64Mi

  ## Repo server service configuration
  service:
    annotations: {}
    labels: {}
    port: 8081
    portName: https-repo-server

  ## Repo server metrics service configuration
  metrics:
    enabled: false
    service:
      annotations: {}
      labels: {}
      servicePort: 8084
    serviceMonitor:
      enabled: false
      interval: 30s
      relabelings: []
      metricRelabelings: []
    #   selector:
    #     prometheus: kube-prometheus
    #   namespace: monitoring
    #   additionalLabels: {}

  ## Repo server service account
  ## If create is set to true, make sure to uncomment the name and update the rbac section below
  serviceAccount:
    create: false
    #  name: argocd-repo-server
    ## Annotations applied to created service account
    annotations: {}
    ## Automount API credentials for the Service Account
    automountServiceAccountToken: true

  ## Repo server rbac rules
  # rbac:
  #   - apiGroups:
  #     - argoproj.io
  #     resources:
  #     - applications
  #     verbs:
  #     - get
  #     - list
  #     - watch

  ## Use init containers to configure custom tooling
  ## https://argoproj.github.io/argo-cd/operator-manual/custom_tools/
  ## When using the volumes & volumeMounts section bellow, please comment out those above.
  #  volumes:
  #  - name: custom-tools
  #    emptyDir: {}
  #
  #  initContainers:
  #  - name: download-tools
  #    image: alpine:3.8
  #    command: [sh, -c]
  #    args:
  #      - wget -qO- https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz | tar -xvzf - &&
  #        mv linux-amd64/helm /custom-tools/
  #    volumeMounts:
  #      - mountPath: /custom-tools
  #        name: custom-tools
  #  volumeMounts:
  #  - mountPath: /usr/local/bin/helm
  #    name: custom-tools
  #    subPath: helm

## Argo Configs
configs:
  ## External Cluster Credentials
  ## reference:
  ## - https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#clusters
  ## - https://argoproj.github.io/argo-cd/operator-manual/security/#external-cluster-credentials
  clusterCredentials: []
    # - name: mycluster
    #   server: https://mycluster.com
    #   labels: {}
    #   annotations: {}
    #   config:
    #     bearerToken: "<authentication token>"
    #     tlsClientConfig:
    #       insecure: false
    #       caData: "<base64 encoded certificate>"
    # - name: mycluster2
    #   server: https://mycluster2.com
    #   labels: {}
    #   annotations: {}
    #   namespaces: namespace1,namespace2
    #   config:
    #     bearerToken: "<authentication token>"
    #     tlsClientConfig:
    #       insecure: false
    #       caData: "<base64 encoded certificate>"

  gpgKeysAnnotations: {}
  gpgKeys: {}
    # 4AEE18F83AFDEB23: |
    #     -----BEGIN PGP PUBLIC KEY BLOCK-----
    #
    #     mQENBFmUaEEBCACzXTDt6ZnyaVtueZASBzgnAmK13q9Urgch+sKYeIhdymjuMQta
    #     x15OklctmrZtqre5kwPUosG3/B2/ikuPYElcHgGPL4uL5Em6S5C/oozfkYzhwRrT
    #     SQzvYjsE4I34To4UdE9KA97wrQjGoz2Bx72WDLyWwctD3DKQtYeHXswXXtXwKfjQ
    #     7Fy4+Bf5IPh76dA8NJ6UtjjLIDlKqdxLW4atHe6xWFaJ+XdLUtsAroZcXBeWDCPa
    #     buXCDscJcLJRKZVc62gOZXXtPfoHqvUPp3nuLA4YjH9bphbrMWMf810Wxz9JTd3v
    #     yWgGqNY0zbBqeZoGv+TuExlRHT8ASGFS9SVDABEBAAG0NUdpdEh1YiAod2ViLWZs
    #     b3cgY29tbWl0IHNpZ25pbmcpIDxub3JlcGx5QGdpdGh1Yi5jb20+iQEiBBMBCAAW
    #     BQJZlGhBCRBK7hj4Ov3rIwIbAwIZAQAAmQEH/iATWFmi2oxlBh3wAsySNCNV4IPf
    #     DDMeh6j80WT7cgoX7V7xqJOxrfrqPEthQ3hgHIm7b5MPQlUr2q+UPL22t/I+ESF6
    #     9b0QWLFSMJbMSk+BXkvSjH9q8jAO0986/pShPV5DU2sMxnx4LfLfHNhTzjXKokws
    #     +8ptJ8uhMNIDXfXuzkZHIxoXk3rNcjDN5c5X+sK8UBRH092BIJWCOfaQt7v7wig5
    #     4Ra28pM9GbHKXVNxmdLpCFyzvyMuCmINYYADsC848QQFFwnd4EQnupo6QvhEVx1O
    #     j7wDwvuH5dCrLuLwtwXaQh0onG4583p0LGms2Mf5F+Ick6o/4peOlBoZz48=
    #     =Bvzs
    #     -----END PGP PUBLIC KEY BLOCK-----

  knownHostsAnnotations: {}
  knownHosts:
    data:
      ssh_known_hosts: |
        bitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==
        github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
        gitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=
        gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
        gitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9
        ssh.dev.azure.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Hr1oTWqNqOlzGJOfGJ4NakVyIzf1rXYd4d7wo6jBlkLvCA4odBlL0mDUyZ0/QUfTTqeu+tm22gOsv+VrVTMk6vwRU75gY/y9ut5Mb3bR5BV58dKXyq9A9UeB5Cakehn5Zgm6x1mKoVyf+FFn26iYqXJRgzIZZcZ5V6hrE0Qg39kZm4az48o0AUbf6Sp4SLdvnuMa2sVNwHBboS7EJkm57XQPVU3/QpyNLHbWDdzwtrlS+ez30S3AdYhLKEOxAG8weOnyrtLJAUen9mTkol8oII1edf7mWWbWVf0nBmly21+nZcmCTISQBtdcyPaEno7fFQMDD26/s0lfKob4Kw8H
        vs-ssh.visualstudio.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Hr1oTWqNqOlzGJOfGJ4NakVyIzf1rXYd4d7wo6jBlkLvCA4odBlL0mDUyZ0/QUfTTqeu+tm22gOsv+VrVTMk6vwRU75gY/y9ut5Mb3bR5BV58dKXyq9A9UeB5Cakehn5Zgm6x1mKoVyf+FFn26iYqXJRgzIZZcZ5V6hrE0Qg39kZm4az48o0AUbf6Sp4SLdvnuMa2sVNwHBboS7EJkm57XQPVU3/QpyNLHbWDdzwtrlS+ez30S3AdYhLKEOxAG8weOnyrtLJAUen9mTkol8oII1edf7mWWbWVf0nBmly21+nZcmCTISQBtdcyPaEno7fFQMDD26/s0lfKob4Kw8H
  tlsCertsAnnotations: {}
  tlsCerts:
    {}
    # data:
    #   argocd.example.com: |
    #     -----BEGIN CERTIFICATE-----
    #     MIIF1zCCA7+gAwIBAgIUQdTcSHY2Sxd3Tq/v1eIEZPCNbOowDQYJKoZIhvcNAQEL
    #     BQAwezELMAkGA1UEBhMCREUxFTATBgNVBAgMDExvd2VyIFNheG9ueTEQMA4GA1UE
    #     BwwHSGFub3ZlcjEVMBMGA1UECgwMVGVzdGluZyBDb3JwMRIwEAYDVQQLDAlUZXN0
    #     c3VpdGUxGDAWBgNVBAMMD2Jhci5leGFtcGxlLmNvbTAeFw0xOTA3MDgxMzU2MTda
    #     Fw0yMDA3MDcxMzU2MTdaMHsxCzAJBgNVBAYTAkRFMRUwEwYDVQQIDAxMb3dlciBT
    #     YXhvbnkxEDAOBgNVBAcMB0hhbm92ZXIxFTATBgNVBAoMDFRlc3RpbmcgQ29ycDES
    #     MBAGA1UECwwJVGVzdHN1aXRlMRgwFgYDVQQDDA9iYXIuZXhhbXBsZS5jb20wggIi
    #     MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCv4mHMdVUcafmaSHVpUM0zZWp5
    #     NFXfboxA4inuOkE8kZlbGSe7wiG9WqLirdr39Ts+WSAFA6oANvbzlu3JrEQ2CHPc
    #     CNQm6diPREFwcDPFCe/eMawbwkQAPVSHPts0UoRxnpZox5pn69ghncBR+jtvx+/u
    #     P6HdwW0qqTvfJnfAF1hBJ4oIk2AXiip5kkIznsAh9W6WRy6nTVCeetmIepDOGe0G
    #     ZJIRn/OfSz7NzKylfDCat2z3EAutyeT/5oXZoWOmGg/8T7pn/pR588GoYYKRQnp+
    #     YilqCPFX+az09EqqK/iHXnkdZ/Z2fCuU+9M/Zhrnlwlygl3RuVBI6xhm/ZsXtL2E
    #     Gxa61lNy6pyx5+hSxHEFEJshXLtioRd702VdLKxEOuYSXKeJDs1x9o6cJ75S6hko
    #     Ml1L4zCU+xEsMcvb1iQ2n7PZdacqhkFRUVVVmJ56th8aYyX7KNX6M9CD+kMpNm6J
    #     kKC1li/Iy+RI138bAvaFplajMF551kt44dSvIoJIbTr1LigudzWPqk31QaZXV/4u
    #     kD1n4p/XMc9HYU/was/CmQBFqmIZedTLTtK7clkuFN6wbwzdo1wmUNgnySQuMacO
    #     gxhHxxzRWxd24uLyk9Px+9U3BfVPaRLiOPaPoC58lyVOykjSgfpgbus7JS69fCq7
    #     bEH4Jatp/10zkco+UQIDAQABo1MwUTAdBgNVHQ4EFgQUjXH6PHi92y4C4hQpey86
    #     r6+x1ewwHwYDVR0jBBgwFoAUjXH6PHi92y4C4hQpey86r6+x1ewwDwYDVR0TAQH/
    #     BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAgEAFE4SdKsX9UsLy+Z0xuHSxhTd0jfn
    #     Iih5mtzb8CDNO5oTw4z0aMeAvpsUvjJ/XjgxnkiRACXh7K9hsG2r+ageRWGevyvx
    #     CaRXFbherV1kTnZw4Y9/pgZTYVWs9jlqFOppz5sStkfjsDQ5lmPJGDii/StENAz2
    #     XmtiPOgfG9Upb0GAJBCuKnrU9bIcT4L20gd2F4Y14ccyjlf8UiUi192IX6yM9OjT
    #     +TuXwZgqnTOq6piVgr+FTSa24qSvaXb5z/mJDLlk23npecTouLg83TNSn3R6fYQr
    #     d/Y9eXuUJ8U7/qTh2Ulz071AO9KzPOmleYPTx4Xty4xAtWi1QE5NHW9/Ajlv5OtO
    #     OnMNWIs7ssDJBsB7VFC8hcwf79jz7kC0xmQqDfw51Xhhk04kla+v+HZcFW2AO9so
    #     6ZdVHHQnIbJa7yQJKZ+hK49IOoBR6JgdB5kymoplLLiuqZSYTcwSBZ72FYTm3iAr
    #     jzvt1hxpxVDmXvRnkhRrIRhK4QgJL0jRmirBjDY+PYYd7bdRIjN7WNZLFsgplnS8
    #     9w6CwG32pRlm0c8kkiQ7FXA6BYCqOsDI8f1VGQv331OpR2Ck+FTv+L7DAmg6l37W
    #     +LB9LGh4OAp68ImTjqf6ioGKG0RBSznwME+r4nXtT1S/qLR6ASWUS4ViWRhbRlNK
    #     XWyb96wrUlv+E8I=
    #     -----END CERTIFICATE-----
## # Creates a secret with optional repository credentials
## DEPRECATED: Instead, use configs.credentialTemplates and/or configs.repositories
  repositoryCredentials: {}

## Creates a secret for each key/value specified below to create repository credentials
  credentialTemplates: {}
    # github-enterprise-creds-1:
    #   url: https://github.com/argoproj
    #   githubAppID: 1
    #   githubAppInstallationID: 2
    #   githubAppEnterpriseBaseUrl: https://ghe.example.com/api/v3
    #   githubAppPrivateKey: |
    #     -----BEGIN OPENSSH PRIVATE KEY-----
    #     ...
    #     -----END OPENSSH PRIVATE KEY-----
    # https-creds:
    #   url: https://github.com/argoproj
    #   password: my-password
    #   username: my-username
    # ssh-creds:
    #  url: git@github.com:argoproj-labs
    #  sshPrivateKey: |
    #    -----BEGIN OPENSSH PRIVATE KEY-----
    #    ...
    #    -----END OPENSSH PRIVATE KEY-----

## Creates a secret for each key/value specified below to create repositories
## Note: the last example in the list would use a repository credential template, configured under "configs.repositoryCredentials".
  repositories: {}
    # istio-helm-repo:
    #   url: https://storage.googleapis.com/istio-prerelease/daily-build/master-latest-daily/charts
    #   name: istio.io
    #   type: helm
    # private-helm-repo:
    #   url: https://my-private-chart-repo.internal
    #   name: private-repo
    #   type: helm
    #   password: my-password
    #   username: my-username
    # private-repo:
    #   url: https://github.com/argoproj/private-repo

  secret:
    createSecret: true
    ## Annotations to be added to argocd-secret
    ##
    annotations: {}

    # Webhook Configs
    githubSecret: ""
    gitlabSecret: ""
    bitbucketServerSecret: ""
    bitbucketUUID: ""
    gogsSecret: ""

    # Custom secrets. Useful for injecting SSO secrets into environment variables.
    # Ref: https://argoproj.github.io/argo-cd/operator-manual/sso/
    # Note that all values must be non-empty.
    extra:
      {}
      # LDAP_PASSWORD: "mypassword"

    # Argo TLS Data.
    argocdServerTlsConfig:
      {}
      # key:
      # crt: |
      #   -----BEGIN CERTIFICATE-----
      #   <cert data>
      #   -----END CERTIFICATE-----
      #   -----BEGIN CERTIFICATE-----
      #   <ca cert data>
      #   -----END CERTIFICATE-----

    # Argo expects the password in the secret to be bcrypt hashed. You can create this hash with
    # `htpasswd -nbBC 10 "" $ARGO_PWD | tr -d ':\n' | sed 's/$2y/$2a/'`
    # argocdServerAdminPassword: ""
    # Password modification time defaults to current time if not set
    # argocdServerAdminPasswordMtime: "2006-01-02T15:04:05Z"

  ## Custom CSS Styles
  ## Reference: https://argo-cd.readthedocs.io/en/stable/operator-manual/custom-styles/
  # styles: |
  #  .nav-bar {
  #    background: linear-gradient(to bottom, #999, #777, #333, #222, #111);
  #  }

openshift:
  enabled: false