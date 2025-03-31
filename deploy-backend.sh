#!/bin/bash
# deploy-backend.sh - Backend deployment script

# Exit on any error
set -e

# Backend Image name
ARTIFACT_REG_REPO=docker-repo
BACKEND_IMAGE_NAME=$REGION-docker.pkg.dev/$PROJECT_ID/$ARTIFACT_REG_REPO/$BACKEND_SERVICE_NAME

# Build backend Docker image
echo "Building backend Docker image..."
cd backend
docker build -t $BACKEND_IMAGE_NAME .

# Push the image to Google Container Registry
echo "Pushing backend image to Google Container Registry..."
docker push $BACKEND_IMAGE_NAME

# Deploy to Cloud Run
echo "Deploying backend to Cloud Run..."
gcloud run deploy $BACKEND_SERVICE_NAME \
  --image $BACKEND_IMAGE_NAME \
  --platform managed \
  --region $REGION \
  --set-env-vars "GEMINI_API_KEY=$GEMINI_API_KEY" \
  --allow-unauthenticated

# Get the URL of the deployed service
BACKEND_URL=$(gcloud run services describe $BACKEND_SERVICE_NAME --platform managed --region $REGION --format 'value(status.url)')
echo "Backend deployed successfully to: $BACKEND_URL"

# Export the backend URL for the frontend to use
export BACKEND_URL
cd ..