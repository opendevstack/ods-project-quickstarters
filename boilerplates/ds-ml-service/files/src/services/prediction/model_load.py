import joblib
import requests
from requests.auth import HTTPBasicAuth

from services.infrastructure.environment import training_auth


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

        with open(git_commit, 'wb') as f:
            f.write(response.content)

        print("model loaded")
        predictor = joblib.load(git_commit)
        return predictor
    except (ConnectionError, ConnectionRefusedError, ConnectionAbortedError,
            ConnectionResetError):
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
        predictor = joblib.load("resources/local.model")
    return predictor
