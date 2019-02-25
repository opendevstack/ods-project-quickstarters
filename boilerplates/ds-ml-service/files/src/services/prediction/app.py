import argparse

import pandas as pd
from flask import jsonify, request

from services.infrastructure.environment import training_host_url, debug_mode
from services.infrastructure.flask import init_flask
from services.infrastructure.git_info import GIT_COMMIT

from services.infrastructure.logging import initialize_logging
from services.prediction.model_load import load_model
from services.infrastructure.environment import prediction_auth


# initialize flask application
TRAINING_POD_URL = training_host_url()
app, _executor, auth = init_flask()
app.config['USERS'] = prediction_auth()


# initialize model. Try loading it, fallback (e.g. training service is not up, yet) set it to None.
# noinspection PyBroadException
try:
    app.config["MODEL"] = load_model(TRAINING_POD_URL, GIT_COMMIT)
except FileNotFoundError:
    print("remote model and local backup model can't be found, for the moment....")
    app.config['MODEL'] = None


@app.route('/predict', methods=['POST'])
@auth.login_required
def predict():
    """Provides the endpoint for getting new predictions from the developed model using a POST
    request json.

    HTTP Request Parameters
    -----------------------
    data : json
        Json post containing at least the *ModelWrapper.source_features*. Otherwise a error will
        be thrown

    HTTP Response
    -------------
    pred_json : json
        Response sent back by the service containing the predicted label/value in the format:
        { prediction : label/value}

    """
    # check if model has been loaded. if not: try to load it
    if not app.config["MODEL"]:
        # noinspection PyBroadException
        try:
            app.config["MODEL"] = load_model(TRAINING_POD_URL, GIT_COMMIT)
        except FileNotFoundError:
            msg = 'No model for prediction loaded yet'
            app.logger.error(msg)
            return jsonify({'error': msg}), 404

    # read json submitted with POST
    data = request.get_json(silent=True)

    # logging received data
    app.logger.info(data)

    # predict new value including feature prep
    try:
        res = app.config["MODEL"].prep_and_predict(data)
        return jsonify(res)
    except KeyError as e:
        msg = 'Problem with the provided json post: {0}'.format(e)
        app.logger.error(msg)
        resp = jsonify({'error': msg})
        resp.status_code = 400
        return resp


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Training model and saving it")
    parser.add_argument("--port", "-p", required=False, default=8080, type=int,
                        help="Port number for the Flask server")
    parser.add_argument("--debug", "-d", action="store_true",
                        help="Enables debug mode in the Flask server")
    parser.add_argument("--local", "-l", required=False, default=False, type=bool,
                        help="setting dummy user name and password for local development")

    flask_args = parser.parse_args()

    initialize_logging("prediction.log")

    if flask_args.local:
        username = "user"
        password = "password"
        app.config['USERS'][username] = password

    app.run('0.0.0.0', flask_args.port, debug=debug_mode() or flask_args.debug)

