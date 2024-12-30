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

resource "helm_release" "vault" {
  name       = "vault"
  chart      = "../Helm/vault"
  namespace  = "default"

  values = [
    file("../Helm/vault/values.yaml")
  ]

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/oci-load-balancer-subnet1"
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

resource "helm_release" "cloudflared_vault" {
  name       = "cloudflared-vault"
  chart      = "../Helm/cloudflared-vault"
  namespace  = "default"

  values = [
    file("../Helm/cloudflared-vault/values.yaml")
  ]
}
