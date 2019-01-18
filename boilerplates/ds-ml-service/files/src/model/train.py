import argparse
import logging

import joblib
import pandas as pd

from model.classifier import ClassificationModel
from services.infrastructure.git_info import GIT_COMMIT


def train(model_name=GIT_COMMIT, path='train.csv'):
    """
    This function is the training entry point and should not be removed!!!!
    :param model_name:
    :param path:
    :return:
    """
    # where to get the data -> hard coded for now
    data = pd.read_csv(path)

    # initiate & train model
    logging.getLogger(__name__).info("Starting classification training...")
    classification_model = ClassificationModel()
    classification_model.prep_and_train(data)
    logging.getLogger(__name__).info("Starting classification training... Done")
    # save model
    with open("{0}.model".format(model_name), 'wb') as file:
        logging.getLogger(__name__).info("Persising the model...")
        joblib.dump(value=classification_model, filename=file)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Traning model and saving it")
    parsed_args = parser.parse_args()

    train(model_name="local", path="resources/train.csv")
