from flask import Blueprint, request, jsonify
from app.services.quiz_generator import generate_quiz
from app.models.quiz import Quiz
from app import db
import logging

quiz_routes = Blueprint('quiz_routes', __name__)
logger = logging.getLogger(__name__)

@quiz_routes.route('/generate', methods=['POST'])
def generate():
    try:
        data = request.get_json()
        content = data.get("content")
        difficulty = data.get("difficulty", "medium")
        num_questions = data.get("num_questions", 5)

        if not content:
            return jsonify({"error": "Missing content"}), 400

        questions_text = generate_quiz(content, difficulty, num_questions)

        # Split and store each question in DB (naive separator: \n)
        stored = []
        for q in questions_text.split("\n"):
            if q.strip():
                parts = q.split("Answer:")
                if len(parts) == 2:
                    question, answer = parts[0].strip(), parts[1].strip()
                    quiz = Quiz(question=question, answer=answer, difficulty=difficulty)
                    db.session.add(quiz)
                    stored.append({"question": question, "answer": answer})
        db.session.commit()
        return jsonify({"saved_questions": stored})

    except Exception as e:
        logger.exception("Quiz generation failed")
        return jsonify({"error": str(e)}), 500

@quiz_routes.route('/quizzes', methods=['GET'])
def get_quizzes():
    quizzes = Quiz.query.all()
    return jsonify([
        {"id": q.id, "question": q.question, "answer": q.answer, "difficulty": q.difficulty}
        for q in quizzes
    ])