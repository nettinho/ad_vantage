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
                "text": "La siguiente imagen es el diseño master de una campaña publicitaria que se va a usar como referencia para validar una nueva imagen que es una variación de la imagen master adaptada para algún medio como pueden ser banners, redes sociales, cartelería, etc"
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
                "text": """Tienes que analizar y validar una series de criterios: 
                    - 'margenes': Loa margenes de la imagen deben ser simétricos, es decir que haya el mismo espacio entre el contenido de la imagen y los bordes. El resultado deberías ser 'Apto' o 'No apto'. En el caso de 'No apto' incluir una breve justificación.
                    - 'contraste': Buen contraste entre los elementos de la imagen y el fondo. El resultado deberías ser 'Apto' o 'No apto'. En el caso de 'No apto' incluir una breve justificación.
                    - 'legibilidad': Legibilidad de los textos. El resultado deberías ser 'Apto' o 'No apto'. En el caso de 'No apto' incluir una breve justificación.
                    - 'redundancia': Inexistencia de redundancia entre los elementos. El resultado deberías ser 'Apto' o 'No apto'. En el caso de 'No apto' incluir una breve justificación.
                    - 'logos_rep': Los logotipos no se pueden repetir. El resultado deberías ser 'Apto' o 'No apto'. En el caso de 'No apto' incluir una breve justificación.
                    - 'cta': Los Call To Action (CTA) no se pueden repetir. El resultado deberías ser 'Apto' o 'No apto'. En el caso de 'No apto' incluir una breve justificación.
                    - 'cta_text': El texto de los Call To Action (CTA) debe ser consistente en mayusculas y minusculas. El resultado deberías ser 'Apto' o 'No apto'. En el caso de 'No apto' incluir una breve justificación.
                    - 'tipografia': Conservación la tipografía de los mensajes clave del diseño master. El resultado deberías ser 'Apto' o 'No apto'. En el caso de 'No apto' incluir una breve justificación.
                    - 'mensaje': Priorización mensajes clave y no saturar con contenido redundante. El resultado deberías ser 'Apto' o 'No apto'. En el caso de 'No apto' incluir una breve justificación.
                """
            },
            {
                "type": "text",
                "text": """Valida la siguiente imagen de forma exhaustiva tomando como referencia el diseño master para algunos de los criterios mencionados.
                    Importante! Tu respuesta debe ser en español en un objeto raw JSON sin formatear (Importante! No incluir ```json) con la siguiente estructura:
                    - Clave: 'validate', Valor: Porcentaje de validez de la adaptación en decimales.
                    - Clave: 'errores', Valor: resumen de las validaciones. Debe contener una lista con cada uno de los criterios a analizar.
                    ['margenes', 'contraste', 'legibilidad', 'redundancia', 'logos_rep', 'cta', 'cta_text', 'tipografia', 'mensaje']
                    Por ejemplo:
                    "errores": [{"margenes": "No apto. El margen derecho es mucho mayor al izquierdo"}, {"contraste": "Apto"}, {"tipografia": "No Apto. La tipografía de la variación con coincide con la de la imagen master"}]
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
