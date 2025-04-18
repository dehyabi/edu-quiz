# OpenQuiz Generator

Generate educational quizzes from any input text, URL, or file using AI (powered by Gemini).

## Features
- Generate quizzes via API
- Multiple choice and short answer support
- REST API with Flask
- Async support with Celery + Redis
- Powered by Google Gemini API
- ✨ Now supports saving and retrieving quizzes via PostgreSQL

## Setup
```bash
docker-compose up --build
```

## API Usage
POST /generate
```json
{
  "content": "The mitochondria is the powerhouse of the cell.",
  "difficulty": "easy",
  "num_questions": 3
}
```

GET /quizzes
Returns all stored quiz questions from database.