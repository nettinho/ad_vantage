import openai
import base64
import requests
import json
from services.llm import GenerativeChatFactory


class Validator:
    def validate_variation(self, url_master, url_variation):
        content = [
            {
                "type": "text",
                "text": "La siguiente imagen es el diseño master."
            },
            {
                "type": "image_url",
                "image_url": {
                "url": url_master,
                "detail": "high"
                },
            },
            {
                "type": "text",
                "text": """Estos son los criterios de validacion: 
                    - Márgenes simetricos.
                    - Buen contraste entre los elementos y el fondo.
                    - Legibilidad de los textos.
                    - Inexistencia de redundancia entre los elementos.
                    - Los logotipos no se pueden repetir.
                    - Los Call To Action (CTA) no se pueden repetir.
                    - El texto de los Call To Action (CTA) debe ser consistente en mayusculas y minusculas.
                    - Conservación la tipografía de los mensajes clave del diseño master.
                    - Priorización mensajes clave y no saturar con contenido redundante.
                """
            },
            {
                "type": "text",
                "text": """Valida la siguiente imagen de forma exhaustiva tomando como referencia el diseño master.
                    Importante! Tu respuesta debe ser en español en un objeto raw JSON sin formatear con la siguiente estructura::
                    - Clave: 'validate', Valor: Porcentaje de validez de la adaptación en decimales.
                    - Clave: 'errores', Valor: resumen de los errores encontrados en formato string.
                """
            },
            {
                "type": "image_url",
                "image_url": {
                "url": url_variation,
                "detail": "high"
                },
            },
        ]

        llm = GenerativeChatFactory.use("ChatOpenAIVision")
        response = llm.send_message(content)

        return response['choices'][0]['message']['content']

    @staticmethod
    def get_as_base64(url):
        response = base64.b64encode(requests.get(url).content).decode('utf-8')
        return response
