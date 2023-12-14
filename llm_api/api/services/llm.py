import os
import json

from abc import ABC, abstractmethod
from langchain.chat_models import ChatOpenAI
from langchain.chains import LLMChain
from langchain_core.messages import HumanMessage
from langchain.llms import Bedrock
from langchain.prompts import PromptTemplate
from openai import AzureOpenAI
from typing import Any


class GenerativeChat(ABC):
    def send_message(content: str) -> Any:
        pass


class GenerativeChatOpenAIVision(GenerativeChat):
    def send_message(self, content: str, max_tokens: int = 700) -> Any:
        client = AzureOpenAI(
            azure_endpoint=os.environ["OPENAI_API_BASE"],
            api_version=os.environ["OPENAI_API_VERSION"],
            api_key=os.environ["OPENAI_API_KEY"],
        )
        completion = client.chat.completions.create(
            model="gpt-4-vision",
            messages=[{
                "role": "user",
                "content": content,
            }],
            max_tokens=max_tokens,
        )

        response = json.loads(completion.model_dump_json())

        return response


class GenerativeChatFactory:
    @abstractmethod
    def use(chat_model) -> GenerativeChat:
        if chat_model == "ChatOpenAIVision":
            return GenerativeChatOpenAIVision()
        else:
            raise NameError(f"Chat model {chat_model} no defined")
