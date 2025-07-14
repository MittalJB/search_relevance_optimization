provider "google" {
  project = var.project_id
  region  = var.region
}

# Create Artifact Registry to store Docker image
resource "google_artifact_registry_repository" "ml_repo" {
  location      = var.region
  repository_id = var.repo_id
  format        = "DOCKER"
}

# Build, tag, and push Docker image to Artifact Registry
resource "null_resource" "docker_build_push" {
  provisioner "local-exec" {
    command = <<EOT
      gcloud auth configure-docker ${var.region}-docker.pkg.dev --quiet
      docker build -t ${var.image_name} ../app
      docker tag ${var.image_name} ${var.region}-docker.pkg.dev/${var.project_id}/${var.repo_id}/${var.image_name}
      docker push ${var.region}-docker.pkg.dev/${var.project_id}/${var.repo_id}/${var.image_name}
    EOT
  }

  depends_on = [google_artifact_registry_repository.ml_repo]
}

# Register the container as a Vertex AI model
resource "google_vertex_ai_model" "xgbranker_model" {
  display_name = "xgb-ranker"

  container_spec {
    image_uri = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repo_id}/${var.image_name}"

    ports {
      container_port = 5000
    }

    predict_route = "/predict"
    health_route  = "/"
  }

  depends_on = [null_resource.docker_build_push]
}

# Create a Vertex AI endpoint
resource "google_vertex_ai_endpoint" "ranker_endpoint" {
  display_name = "xgb-ranker-endpoint"
}

# Deploy model to endpoint
resource "google_vertex_ai_endpoint_deployment" "deploy_model" {
  endpoint = google_vertex_ai_endpoint.ranker_endpoint.name
  model    = google_vertex_ai_model.ranker_model.name

  deployed_model {
    display_name = "xgb-ranker-deployment"

    automatic_resources {
      min_replica_count = 1
      max_replica_count = 1
    }
  }

  depends_on = [
    google_vertex_ai_model.xgbranker_model,
    google_vertex_ai_endpoint.ranker_endpoint
  ]
}
