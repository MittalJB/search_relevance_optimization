FROM python:3.11-slim

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your model.pkl file and example app
COPY xbgranker_model.pkl .
COPY app.py .

# Expose port for the Flask app
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]

