resource "helm_release" "reminder_app" {
  name       = "reminder-app"
  chart      = "../Helm/reminder-app"
  namespace  = "default"

  values = [
    file("../Helm/reminder-app/values-production.yaml")
  ]

  set {
    name  = "nginx.service.annotations.service\\.beta\\.kubernetes\\.io/oci-load-balancer-subnet1"
    value = oci_core_subnet.worker_subnet.id
  }

  depends_on = [oci_core_subnet.worker_subnet]
}

resource "helm_release" "cloudflared" {
  name       = "cloudflared"
  chart      = "../Helm/cloudflared"
  namespace  = "default"

  values = [
    file("../Helm/cloudflared/values.yaml")
  ]
}

resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  namespace  = "default"
}
