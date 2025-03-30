#!/bin/bash
# deploy-frontend.sh - Frontend deployment script

# Exit on any error
set -e

# Check if backend URL is available
if [ -z "$BACKEND_URL" ]; then
    # If not set by deploy-backend.sh, try to get it from gcloud
    BACKEND_URL=$(gcloud run services describe $BACKEND_SERVICE_NAME --platform managed --region $REGION --format 'value(status.url)' 2>/dev/null || echo "")
    
    if [ -z "$BACKEND_URL" ]; then
        echo "Error: BACKEND_URL is not set and could not be retrieved from Google Cloud Run"
        exit 1
    fi
fi

# Move to frontend directory
cd frontend

# Build the React app with the backend URL
echo "Building React app with backend URL: $BACKEND_URL"
REACT_APP_API_URL=$BACKEND_URL npm run build

# Write the backend url to the .env file
echo REACT_APP_API_URL=$BACKEND_URL > .env

# Build frontend Docker image
echo "Building frontend Docker image..."
ARTIFACT_REG_REPO=docker-repo
FRONTEND_IMAGE_NAME=$REGION-docker.pkg.dev/$PROJECT_ID/$ARTIFACT_REG_REPO/$FRONTEND_SERVICE_NAME
docker build -t $FRONTEND_IMAGE_NAME .

# Push the image to Google Container Registry
echo "Pushing frontend image to Google Container Registry..."
docker push $FRONTEND_IMAGE_NAME

# Deploy to Cloud Run
echo "Deploying frontend to Cloud Run..."
gcloud run deploy $FRONTEND_SERVICE_NAME \
  --image $FRONTEND_IMAGE_NAME \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --set-env-vars "BACKEND_URL=$BACKEND_URL"

# Get the URL of the deployed service
FRONTEND_URL=$(gcloud run services describe $FRONTEND_SERVICE_NAME --platform managed --region $REGION --format 'value(status.url)')
echo "Frontend deployed successfully to: $FRONTEND_URL"

# Update the backend CORS_ALLOW_ORIGIN env variable
gcloud run services update $BACKEND_SERVICE_NAME \
 --update-env-vars CORS_ALLOW_ORIGIN=$FRONTEND_URL \
 --region us-central1

cd ..

echo "Application is now accessible at: $FRONTEND_URL"