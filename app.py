import pickle
from flask import Flask, request, jsonify

app = Flask(__name__)

# Load model.pkl
with open("xgbranker_model.pkl", "rb") as f:
    model = pickle.load(f)

@app.route("/predict", methods=["POST"])
def predict():
    data = request.json
    features = data.get("features")  # Expecting a list or dict of features

    # For demo: assuming features is a list of floats matching your model input
    prediction = model.predict([features]).tolist()

    return jsonify({"prediction": prediction})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
