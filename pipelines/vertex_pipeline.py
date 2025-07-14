from google.cloud import aiplatform

aiplatform.init(project='your-project-id', location='us-central1')

model = aiplatform.Model.upload(
    display_name="xgboost-recommendation",
    artifact_uri="gs://your-bucket/model/",
    serving_container_image_uri="us-docker.pkg.dev/vertex-ai/prediction/xgboost-cpu.1-5:latest"
)

endpoint = model.deploy(machine_type="n1-standard-4")
