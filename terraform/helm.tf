resource "helm_release" "reminder_app" {
  name       = "reminder-app"
  chart      = "../Helm/reminder-app"
  namespace  = "default"

  values = [
    file("../Helm/reminder-app/values.yaml")
  ]

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "image.tag"
    value = "latest"
  }
}

resource "helm_release" "cloudflared" {
  name       = "cloudflared"
  chart      = "../Helm/cloudflared"
  namespace  = "default"

  values = [
    file("../Helm/cloudflared/values.yaml")
  ]

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "image.tag"
    value = "latest"
  }
}
