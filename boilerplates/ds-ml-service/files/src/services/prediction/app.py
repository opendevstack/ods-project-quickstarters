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
    app.config["MODEL"] = app.config["MODEL"] = load_model(TRAINING_POD_URL, GIT_COMMIT)
except Exception:
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
        except Exception:
            msg = 'No model for prediction loaded yet'
            app.logger.error(msg)
            return jsonify({'error': msg}), 404

    # read json submitted with POST
    data = request.get_json(silent=True)

    # logging received data
    app.logger.info(data)

    # Checking data object on consistency
    if set(data.keys()).difference(app.config["MODEL"].source_features):
        msg = 'Not all prediction characteristics provided'
        app.logger.error(msg)
        resp = jsonify({'error': msg})
        resp.status_code = 400
        return resp

    # convert json to pandas data frame -> be able to use the same feature processing functions
    input_data = pd.DataFrame(data, index=[0])

    # predict new value including feature prep
    res = app.config["MODEL"].prep_and_predict(input_data)
    pred_json = jsonify({'prediction': res})

    return pred_json


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Training model and saving it")
    parser.add_argument("--port", "-p", required=False, default=8080, type=int, help="Port number for the Flask server")
    parser.add_argument("--debug", "-d", action="store_true", help="Enables debug mode in the Flask server")

    flask_args = parser.parse_args()

    initialize_logging("prediction.log")
    app.run('0.0.0.0', flask_args.port, debug=debug_mode() or flask_args.debug)
