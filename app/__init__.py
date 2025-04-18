from flask import Flask
from .routes import quiz_routes
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
import os

# Initialize SQLAlchemy
db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config.from_pyfile("../config.py")
    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv("DATABASE_URL")
    CORS(app)
    db.init_app(app)
    app.register_blueprint(quiz_routes)
    return app