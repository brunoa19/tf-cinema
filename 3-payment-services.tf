provider "shipa" {
  host = "htt://target.shipa.cloud:8080"
  token = var.SHIPA_TOKEN
}

# Payment app - Create App

resource "shipa_app" "payment" {
  app {
    name = "payment-services"
    teamowner = "shipa-team"
    framework = "payment-service"
  }
  depends_on = [shipa_app.notification]
}

# Payment app - Set env variables

resource "shipa_app_env" "paymentenv" {
  app = "payment-services"
  app_env {
    envs {
      name = "DB_SERVER"
      value = var.DB_SERVER
    }
    envs {
      name = "DB_USER"
      value = var.DB_USER
    }
    envs {
      name = "DB_PASS"
      value = var.DB_PASS
    }
    envs {
      name = "DB"
      value = "booking"
    }
    envs {
      name = "STRIPE_SECRET"
      value = var.STRIPE_SECRET
    }
    envs {
      name = "STRIPE_PUBLIC"
      value = var.STRIPE_PUBLIC
    }
    norestart = true
    private = false
  }
  depends_on = [shipa_app.payment]
}


# Payment app - Deploy app

resource "shipa_app_deploy" "paymentdeploy" {
  app = "payment-services"
  deploy {
    image = "gcr.io/cosimages-206514/cinema-catalog-service@sha256:6613440a460e9f1e6e75ec91d8686c1aa11844b3e7c5413e241c807ce9829498"
  }
  depends_on = [shipa_app_env.paymentenv]
}
