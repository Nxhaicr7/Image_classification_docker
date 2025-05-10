from flask import Flask, render_template, request, url_for, jsonify
from Inference import inference_from_path, inference_from_base64
import os
from werkzeug.utils import secure_filename

#Initialize Flask and saving photo folder
app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = "static/"

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        if "file" not in request.files:
            return "No file", 400
        file = request.files["file"]
        if file.filename == "":
            return "No selected file", 400
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config["UPLOAD_FOLDER"], filename)
        file.save(filepath)
        label, score, resized_image_path = inference_from_path(filepath)
        resized_image_url = url_for('static', filename=os.path.basename(resized_image_path))
        return render_template("index.html", prediction=f"{label} ({score:.2f})", image_path=resized_image_url)
    return render_template("index.html")

@app.route("/webcam")
def webcam():
    return render_template("webcam.html")

@app.route("/api/predict_webcam", methods=["POST"])
def predict_webcam():
    data = request.get_json()
    if not data or 'image' not in data:
        return jsonify({"error": "No image data"}), 400

    #Loại bỏ prefix "data:image/jpeg;base64,"
    base64_data = data["image"].split(",")[1]
    label, score = inference_from_base64(base64_data)
    return jsonify({"label": label, "score": f"{score:.2f}"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)