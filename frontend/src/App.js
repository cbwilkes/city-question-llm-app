import React, { useState } from 'react';

const ENDPOINT_CITY_QUESTION = 'http://localhost:8000';

export default function CityQuestionApp() {
  const [question, setQuestion] = useState('');
  const [answer, setAnswer] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!question.trim()) return;
    
    setLoading(true);
    setAnswer('');
    
    try {
      const response = await fetch(`${ENDPOINT_CITY_QUESTION}/api/city-question`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ question }),
      });
      
      const data = await response.json();
      setAnswer(data.answer);
    } catch (error) {
      console.error('Error fetching answer:', error);
      setAnswer('Sorry, there was an error processing your question.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col items-center justify-center p-4">
      <div className="w-full max-w-md bg-white rounded-lg shadow-md p-6">
        <h1 className="text-2xl font-bold text-gray-800 mb-6 text-center">City Questions</h1>
        
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label htmlFor="question" className="block text-sm font-medium text-gray-700 mb-1">
              Ask a question about any city:
            </label>
            <input
              type="text"
              id="question"
              value={question}
              onChange={(e) => setQuestion(e.target.value)}
              placeholder="E.g., What's the population of Tokyo?"
              className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              required
            />
          </div>
          
          <button
            type="submit"
            disabled={loading}
            className="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50"
          >
            {loading ? 'Loading...' : 'Ask Question'}
          </button>
        </form>
        
        {answer && (
          <div className="mt-6 p-4 bg-gray-100 rounded-md">
            <h2 className="text-lg font-medium text-gray-800 mb-2">Answer:</h2>
            <p className="text-gray-700">{answer}</p>
          </div>
        )}
      </div>
    </div>
  );
}