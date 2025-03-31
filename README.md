# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).


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

### Start using with Docker Compose

```
GEMINI_API_KEY=... docker-compose up --build
```

The frontend should be running at http://localhost:3000 and the backend should be running at http://localhost:8000

### To Deploy to Cloud Run

```
GEMINI_API_KEY=... ./deploy.sh
```