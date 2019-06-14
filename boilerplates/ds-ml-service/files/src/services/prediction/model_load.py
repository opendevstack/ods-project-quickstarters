import joblib
import requests
from requests.auth import HTTPBasicAuth
from requests.exceptions import RequestException

from services.infrastructure.environment import training_auth


import os


def load_remote_model(train_pod_url, git_commit):
    """Helper function for loading a model from the remote training service. Using the *getmodel*
    endpoint of the training service.

    Parameters
    ----------
    train_pod_url : String
        url of the training service
    git_commit : String

    Returns
    -------
    predictor : ModelWrapper object
        Wrapped algorithm in the ModelWrapper class

    """
    auth = training_auth()
    if not auth:
        return None

    username, password = auth.popitem()
    try:
        response = requests.get(
            '{0}/getmodel'.format(train_pod_url),
            auth=HTTPBasicAuth(username=username, password=password),
            stream=True)

        if response.status_code == 200:
            with open(git_commit, 'wb') as f:
                f.write(response.content)
            predictor = joblib.load(git_commit)
            print("model loaded")
        else:
            print("/getmodel endpoint from training pod returned: {0}".format(response.content))
            return None

        return predictor
    except (ConnectionError, ConnectionRefusedError, ConnectionAbortedError,
            ConnectionResetError, RequestException):
        print("remote training pod not reachable")
        return None


def load_model(train_pod_url, git_commit):
    """Helper function for leading a local model.

    See Also
    --------
    *load_remote_model*

    """
    predictor = load_remote_model(train_pod_url, git_commit)
    if not predictor:
        predictor = joblib.load("{}.model".format(git_commit))
    return predictor
