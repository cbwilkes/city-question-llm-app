# Gemini Structured Output Demo

This application showcases how to leverage the [Gemini API](https://ai.google.dev/) to 
extract structured data from natural language queries and 
demonstrates a deployment workflow to [Google Cloud Run](https://cloud.google.com/run)

It consists of a React frontend that communicates with a 
FastAPI Python backend. The backend utilizes the Pydantic library 
to define the desired output structure, allowing Gemini to return data 
in a predictable and usable format.

The interface queries the user for questions related to a city and returns structured output.

**Key Features:**

* Demonstrates Gemini's ability to provide structured output.
* Utilizes a React frontend for user interaction.
* Employs a FastAPI backend for API handling.
* Leverages Pydantic for defining and validating structured output.
* Illustrates how structured output can be used to integrate with other APIs.
* Includes configurations for deploying the backend to Google Cloud Run.
* Provides an example of a serverless deployment workflow.

**How it Works:**

1.  The user enters a natural language query in the React frontend.
1.  The frontend sends the query to the FastAPI backend.
1.  The backend uses the Gemini API, guided by a Pydantic model, to extract structured information from the query.
1.  The structured output is returned to the frontend.
1.  (Optional) The backend can then use this structured output to call other APIs

## Getting started - Local Development

### Start the frontend

Install dependencies:

```
npm install
```

Start the dev server:

```
npm start
```

### Start the backend

Install dependencies:

```
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

To run the backend server, include the GEMINI_API_KEY:

```
cd backend
source venv/bin/activate
GEMINI_API_KEY=... uvicorn main:app --reload
```

### Using Docker Compose

```
GEMINI_API_KEY=... docker-compose up --build
```

The frontend should be running at http://localhost:3000 and the backend should be running at http://localhost:8000

## Deployment to Cloud Run

Setup Artifact Registry authentication:

1. Follow instructions at https://cloud.google.com/artifact-registry/docs/docker/authentication
1. Create a Docker based Artifact Registry repository named `docker-repo`

Run the deployment script:

```
GEMINI_API_KEY=... ./deploy.sh
```