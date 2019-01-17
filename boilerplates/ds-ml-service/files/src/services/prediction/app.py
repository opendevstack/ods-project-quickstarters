import argparse

import joblib
import pandas as pd
import requests
from flask import jsonify, request
from requests.auth import HTTPBasicAuth

from services.infrastructure.environment import training_host_url, prediction_auth, training_auth, debug_mode
from services.infrastructure.flask import init_flask
from services.infrastructure.git_info import GIT_COMMIT
from services.infrastructure.logging import initialize_logging

TRAINING_POD_URL = training_host_url()
predictor = None

app, _executor, auth = init_flask()
users = None


def setup_local_test_users(username, password):
    global users
    users = {
        username: password
    }


@auth.get_password
def get_password(username):
    global users
    if not users:
        users = prediction_auth()

    if username in users:
        return users.get(username)
    return None


def load_remote_model():
    auth = training_auth(raiseException=False)
    if not auth:
        return None

    username, password = auth.popitem()
    response = requests.get(
        '{0}/getmodel'.format(TRAINING_POD_URL), auth=HTTPBasicAuth(username=username, password=password), stream=True)
    with open(GIT_COMMIT, 'wb') as f:
        f.write(response.content)

    print("model loaded")
    _predictor = joblib.load(GIT_COMMIT)
    return _predictor


def load_local_model():
    return joblib.load("resources/local.model")


def load_model():
    global predictor

    if predictor:
        return predictor

    predictor = load_remote_model()
    if not predictor:
        predictor = load_local_model()

    return predictor


@app.route('/predict', methods=['POST'])
@auth.login_required
def predict():
    global predictor

    if not predictor:
        # noinspection PyBroadException
        try:
            predictor = load_model()
        except Exception:
            msg = 'No model for prediction loaded yet'
            app.logger.error(msg)
            return jsonify({'error': msg}), 404

    # read json submitted with POST
    data = request.get_json(silent=True)

    # logging received data
    app.logger.info(data)

    # Checking data object on consistency
    if set(data.keys()).difference(predictor.source_features):
        msg = 'Not all prediction characteristics provided'
        app.logger.error(msg)
        resp = jsonify({'error': msg})
        resp.status_code = 400
        return resp

    # convert json to pandas dataframe -> be able to use the same feature processing functions
    input_data = pd.DataFrame(data, index=[0])

    # predict new value including feature prep
    res = predictor.prep_and_predict(input_data)

    return jsonify({'prediction': res})


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Traning model and saving it")
    parser.add_argument("--port", "-p", required=False, default=8080, type=int, help="Port number for the Flask server")
    parser.add_argument("--debug", "-d", action="store_true", help="Enables debug mode in the Flask server")

    flask_args = parser.parse_args()

    initialize_logging("prediction.log")
    app.run('0.0.0.0', flask_args.port, debug=debug_mode() or flask_args.debug)
