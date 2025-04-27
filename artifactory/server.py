from flask import Flask, request, send_from_directory, jsonify
import os

UPLOAD_DIR = "./repo"
os.makedirs(UPLOAD_DIR, exist_ok=True)

app = Flask(__name__)


@app.route("/", methods=["GET"])
def list_files():
    try:
        entries = os.listdir(UPLOAD_DIR)
        return jsonify(entries)
        # return entries
        # return "coucou"
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/<path:filename>", methods=["GET"])
def download_file(filename):
    return send_from_directory(UPLOAD_DIR, filename)

@app.route("/<path:filename>", methods=["PUT", "POST"])
def upload_file(filename):
    with open(os.path.join(UPLOAD_DIR, filename), 'wb') as f:
        f.write(request.get_data())
    return "Uploaded", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8082)
