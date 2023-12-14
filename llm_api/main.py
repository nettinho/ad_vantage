import numpy as np
from PIL import Image
from lang_sam import LangSAM


def segment_elements(categories: list[dict], image: Image, model: LangSAM):
    result = {}
    for cat in categories:
        masks, boxes, labels, logits = model.predict(image, cat["prompt"])

        masks_selected = [masks[np.argmax(logits)]]
        boxes_selected = [boxes[np.argmax(logits)]]
        labels_selected = [labels[np.argmax(logits)]]
        logits_selected = [logits[np.argmax(logits)]]

        cat["masks"] = masks_selected
        cat["boxes"] = boxes_selected
        cat["labels"] = labels_selected
        cat["logits"] = logits_selected
        result[cat["name"]] = cat
    return result


def main():
    categories = [
        {
            "id": 0,
            "name": "BackgroundImage",
            "prompt": "persons"
        },
        {
            "id": 1,
            "name": "Button",
            "prompt": "button with text"
        },
        {
            "id": 2,
            "name": "Icon",
            "prompt": "group of icons"
        },
        {
            "id": 3,
            "name": "Logo",
            "prompt": "company logo"
        },
        {
            "id": 4,
            "name": "Text",
            "prompt": "group of text"
        }
    ]
    IMAGE_PATH = 'images/master.png'

    image_pil = Image.open(IMAGE_PATH).convert("RGB")
    model = LangSAM()

    results = segment_elements(categories, image_pil, model)
    print(results)


if __name__ == "__main__":
    main()
