from flask import Flask
from flask_cors import CORS, cross_origin
from dotenv import load_dotenv
import requests

app = Flask(__name__)
CORS(app, support_credentials=True)

load_dotenv()


@app.route('/')
def home():
    return "Hello!!"


@app.route('/jokes', methods=['GET'])
@cross_origin(supports_credentials=True)
def get_jokes():
    response = requests.get('https://api.yomomma.info')

    return response.json()


app.run(host='0.0.0.0', port=8000)
