import os
import requests
import json

def generate_quiz(content, difficulty="medium", num_questions=5):
    api_key = os.getenv("GEMINI_API_KEY")
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={api_key}"

    prompt = f"Generate {num_questions} {difficulty} level quiz questions (MCQ and short answers) from this:\n{content}"

    payload = {
        "contents": [
            {"parts": [{"text": prompt}]}
        ]
    }

    headers = {"Content-Type": "application/json"}
    response = requests.post(url, headers=headers, data=json.dumps(payload))

    if response.status_code == 200:
        return response.json().get("candidates", [])[0].get("content", {}).get("parts", [{}])[0].get("text", "No questions generated")
    else:
        return f"Error: {response.text}"