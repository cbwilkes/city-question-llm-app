import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import uvicorn

from pydantic_ai import Agent
from pydantic_ai.models.gemini import GeminiModel
from pydantic_ai.providers.google_gla import GoogleGLAProvider

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


class PlaceToVisit(BaseModel):
    places_to_visit: list[str] = Field(description='3 Places to visit in the city as a tourist')
    reasons: str = Field(description='Reasons to visit in the city')
    hidden_gems: str = Field(description='Lesser known paid activities to visit in the city')
    city: str
    state: str
    country: str
    confidence: float
    latitude: float = Field(description='Latitude of the city')
    longitude: float = Field(description='Longitude of the city')


api_key = os.environ['GEMINI_API_KEY']

model = GeminiModel(
    'gemini-2.0-flash',
    provider=GoogleGLAProvider(
        api_key=api_key
    )
)

agent = Agent(
    model,
    result_type=PlaceToVisit, 
    instrument=True,
    system_prompt=(
        'You are a travel agent, give the customer exciting'
        'reasons to visit the city.  Available tools: final_result'
    ),
)


async def prompt(query: QuestionRequest) -> PlaceToVisit:
    result = await agent.run(query.question)
    
    return result.data


@app.post("/api/city-question")
async def answer_city_question(request: QuestionRequest):
    try:
        answer = await prompt(request)

        return {
            "answer": f"Here's information about the city related to the question: '{request.question}'. City: {answer.city}, {answer.state}"
        }
    except Exception as e:
        print(e)
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
