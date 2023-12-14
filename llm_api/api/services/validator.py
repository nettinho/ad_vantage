import openai
import base64
import requests
import json
from services.llm import GenerativeChatFactory


class Validator:
    def validate_variation(self, payload):
        llm = GenerativeChatFactory.use("ChatOpenAIVision")
        response = llm.send_message(payload)

        return response['choices'][0]['message']['content']

    @staticmethod
    def get_as_base64(url):
        response = base64.b64encode(requests.get(url).content).decode('utf-8')
        return response
