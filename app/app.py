#!venv/bin/python
import socket
import os
import datetime
import flask
from flask import request, jsonify

app = flask.Flask(__name__)
app.config["DEBUG"] = True


@app.route('/', methods=['GET'])
def api():
    return jsonify(dict(HOST=socket.gethostname(),
            CONFIG=str(os.environ.get('PYTHON_HOSTNAME_ENV_VERSION')),
            TIME=datetime.datetime.now().strftime("%H:%M:%S")))


app.run(host='0.0.0.0', port=5080, debug=True)