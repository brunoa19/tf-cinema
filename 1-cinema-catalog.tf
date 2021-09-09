# Cinema Catalog app - Create App

resource "shipa_app" "cinemacatalog" {
  app {
    name = "cinema-catalog"
    teamowner = "shipa-team"
    framework = "cinema-services"
  }
  depends_on = [shipa_app.moviesapp]
}

# Cinema Catalog app - Set env variables

resource "shipa_app_env" "cinecatalogenv" {
  app = "cinema-catalog"
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
      value = "cinemas"
    }
    norestart = true
    private = false
  }
  depends_on = [shipa_app.cinemacatalog]
}


# Cinema Catalog  app - Deploy app

resource "shipa_app_deploy" "cinecatalogdeploy" {
  app = "cinema-catalog"
  deploy {
    image = "gcr.io/cosimages-206514/cinema-catalog-service@sha256:6613440a460e9f1e6e75ec91d8686c1aa11844b3e7c5413e241c807ce9829498"
  }
  depends_on = [shipa_app_env.cinecatalogenv]
}
