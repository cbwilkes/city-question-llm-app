from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn


app = FastAPI()

# Enable CORS to allow requests from your React frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class QuestionRequest(BaseModel):
    question: str

@app.post("/api/city-question")
async def answer_city_question(request: QuestionRequest):
    # This is a dummy response
    # In a real app, you might call an external API or database
    try:
        return {
            "answer": f"Here's information about the city mentioned in: '{request.question}'. This is a dummy response from the FastAPI backend."
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
