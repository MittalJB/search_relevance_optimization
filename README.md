# search_relevance_optimization




# Build Docker image
docker build -t xgb-flask-app .

# Run container
docker run -p 5000:5000 xgb-flask-app


curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{"features": [0.5, 0.7]}'
