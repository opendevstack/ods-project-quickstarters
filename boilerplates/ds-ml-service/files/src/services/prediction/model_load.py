import joblib
import requests
from requests.auth import HTTPBasicAuth

from services.infrastructure.environment import training_auth


def load_remote_model(train_pod_url, git_commit):
    auth = training_auth()
    if not auth:
        return None

    username, password = auth.popitem()
    response = requests.get(
        '{0}/getmodel'.format(train_pod_url), auth=HTTPBasicAuth(username=username, password=password),
        stream=True)
    with open(git_commit, 'wb') as f:
        f.write(response.content)

    print("model loaded")
    _predictor = joblib.load(git_commit)
    return _predictor


def load_model(train_pod_url, git_commit):
    predictor = load_remote_model(train_pod_url, git_commit)
    if not predictor:
        predictor = joblib.load("resources/local.model")
    return predictor
