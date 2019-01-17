import argparse
import time

import requests
from requests.auth import HTTPBasicAuth

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

    # start training
    response = None
    count = 0
    print("Training server is on: {0}".format(host))
    time.sleep(30)
    while count < 20:
        try:
            response = requests.get(
                '{0}/start'.format(host), auth=auth, stream=True)

            break
        except Exception:
            count += 1
            time.sleep(5)
            continue

    if not response or response.status_code != 202:
        print("Training service not reachable!")
        exit(1)

    print("Training started....")

    # check every 5 seconds inf training has finished
    training_finished = False
    while not training_finished:
        try:
            print("Waiting for the training to finished...")
            response = requests.get(
                '{0}/finished'.format(host), auth=auth, stream=True)
            res_json = response.json()
            if res_json['finished']:
                training_finished = True
                print("Training finished")
                break
        finally:
            time.sleep(5)
