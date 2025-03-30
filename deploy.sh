#!/bin/bash
# deploy.sh - Master deployment script

# Exit on any error
set -e

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    source .env
fi

# Set default values for environment variables
export PROJECT_ID=${PROJECT_ID:-"chordeo-1176"}
export FRONTEND_SERVICE_NAME=${FRONTEND_SERVICE_NAME:-"city-question-llm-frontend"}
export BACKEND_SERVICE_NAME=${BACKEND_SERVICE_NAME:-"city-question-llm-backend"}
export REGION=${REGION:-"us-central1"}

# Check if required environment variables are set
if [ -z "$PROJECT_ID" ]; then
    echo "Error: PROJECT_ID environment variable is not set"
    exit 1
fi

# Print deployment information
echo "Deploying to Google Cloud Run:"
echo "  Project ID: $PROJECT_ID"
echo "  Region: $REGION"
echo "  Frontend Service: $FRONTEND_SERVICE_NAME"
echo "  Backend Service: $BACKEND_SERVICE_NAME"

# Deploy backend
./deploy-backend.sh

# Deploy frontend (after backend, so we can get the backend URL)
./deploy-frontend.sh

echo "Deployment completed successfully!"