import argparse
import time

import requests
from requests import RequestException
from requests.auth import HTTPBasicAuth


def start_training(host_url, http_auth):
    """Starts the training on the training service as soon as the pod in openshift is ready.

    Notes
    -----
    Every 5 seconds it is checked if the training can be started, i.e. the training pod is
    running. Will be shutdown after 150 seconds which would mean that the deployment of the
    training service was most likely not successful.

    Parameters
    ----------
    host_url : String
        Training service url
    http_auth : request.auth.HTTPBasicAuth
        set with username and password for authenticating against the training service


    Returns
    -------
    success : bool
        indicates the success of the result of the training process

    """
    response = None
    count = 0
    print("Training server is on: {0}".format(host_url))

    while count < 30:
        # noinspection PyBroadException
        try:
            response = requests.get(
                '{0}/start'.format(host_url), auth=http_auth, stream=True)
            success = True
            return success
        except (ConnectionRefusedError, ConnectionError, OSError, RequestException):
            count += 1
            time.sleep(5)
            continue

    if not response or response.status_code != 202:
        print("Training service not reachable!")
        success = False
        return success


def wait_for_training():
    """check every 5 seconds if the training has finished using the *finished* endpoint fromt he
    training service

    Returns
    -------
    finished : bool
        indicating if the training has finished successful

    """
    finished = False
    while not finished:
        try:
            print("Waiting for the training to finished...")
            response = requests.get(
                '{0}/finished'.format(host), auth=auth, stream=True)
            res_json = response.json()
            if res_json['finished']:
                finished = True
                print("Training finished")
                return finished
        finally:
            time.sleep(5)


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description="Wait for training pod to finish training")
    parser.add_argument("--training-service", "-s", dest="host", required=True, type=str,
                        help="The training pod base url (without any path)")
    parser.add_argument("--username", "-u", required=True, type=str,
                        help="The training service username")
    parser.add_argument("--password", "-o", required=True, type=str,
                        help="The training service password")

    args = parser.parse_args()

    host = args.host
    auth = HTTPBasicAuth(username=args.username, password=args.password)

    training_started = start_training(host, auth)

    if training_started:
        training_finished = wait_for_training()
