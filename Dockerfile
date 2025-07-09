# Use official Python image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy your project files into container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Download NLTK data (optional, depending on your code)
RUN python -m nltk.downloader punkt stopwords wordnet

# Expose port if your app is a web service (optional)
# EXPOSE 8080

# Default command to run your app (adjust as needed)
CMD ["python", "app.py"]
