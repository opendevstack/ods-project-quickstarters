import argparse
import logging

import joblib
import pandas as pd

from model.model_wrapper import ModelWrapper
from services.infrastructure.git_info import GIT_COMMIT

from sklearn.metrics import accuracy_score


def train(model_name=GIT_COMMIT, train_data='train.csv'):
    """This function is the training entry point and should not be removed. Executes the
    *ModelWrapper.prep_and_train* and saves the model using *joblib*. MANDATORY

    Notes
    -----
    This function can also be used for your local exploration/development. See the
    >>> if __name__ and "__main__"

    Parameters
    ----------
    model_name : String
        given the trained model a name to store. Default: git_commit id.
    train_data : String
        path where to find the train data.
    """
    # where to get the data -> hard coded for now
    data = pd.read_csv(train_data)

    # initiate & train model
    logging.getLogger(__name__).info("Starting classification training...")
    classification_model = ModelWrapper()
    classification_model.prep_and_train(data)
    logging.getLogger(__name__).info("Starting classification training... Done")
    # save model
    with open("{0}.model".format(model_name), 'wb') as file:
        logging.getLogger(__name__).info("Persisting the model...")
        joblib.dump(value=classification_model, filename=file)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Training model and saving it")
    parser.add_argument("--input", "-i", type=str, help="Input file for training",
                        default="resources/train.csv")
    parser.add_argument("--output", "-o", type=str, help="output model name", default="local")
    parsed_args = parser.parse_args()

    train(model_name="local2", train_data=parsed_args.input)

    model = joblib.load("local2.model")

    # load test Dataframe
    test_df = pd.read_csv("resources/test.csv")
    res = model.prep_and_predict_batch(test_df)
    print(res, test_df['Species'].values)

    print(accuracy_score(res, test_df["Species"].values))





