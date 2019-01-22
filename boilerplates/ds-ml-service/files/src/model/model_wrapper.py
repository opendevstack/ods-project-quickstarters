from sklearn.linear_model import LogisticRegression

from model.data_cleaning.replace import replace_strings, replace_missing
from model.feature_prep.polynomial import add_polynomial


class ModelWrapper(object):
    """Wrap custom models into a common interface that is expected by the training and prediction
    service. Needs to provide MANDATORY functions: PREP_AND_PREDICT as well as TRAIN_AND_PREDICT.

    Example code is showcased on a simple model for the iris flower data set.

    Attributes
    ----------
    model : object
    source_features : list
        contains the names of the source features that are used for training and prediction. Is
        also used to select the features that are posted in the json request
    target_variable : string
        name of the target variable, for training the model
    final_features : list
        contains name of the features that are finally feed to the model, after possible
        feature engineering
    """
    def __init__(self):
        self.model = LogisticRegression()
        self.source_features = ["sepalLength", "sepalWidth", "petalWidth"]
        self.target_variable = "Species"
        self.final_features = []

    def prep_and_predict(self, df):
        """Does feature preparation and executes the prediction for *self.model*. MANDATORY

        Parameters
        ----------
        df : pandas.DataFrame
            DataFrame with one row (for single prediction) containing at least
            *self.source_features* + optionally superfluously that will be ignored.

        Notes
        -----
        DataFrame with a single row as input was chosen to be able to use the same feature
        preperation/engineering code as for the training function.


        Returns
        -------
        res : label
            Label predicted by the algorithm
        """
        # restrict to known source features
        df = df[self.source_features]

        # find all not used source features
        not_used_source = df[df.columns.difference(self.source_features)].columns.values.tolist()
        if not_used_source:
            print("Warning: Features: {} are not being used but given".format(not_used_source))

        # feature preparation
        prep_data_df = self._prep_feature_df(df)
        prep_data = prep_data_df.values

        res = self.model.predict(prep_data).tolist()[0]
        return res

    def prep_and_train(self, df):
        """Does feature preparation and executes the training for *self.model*. MANDATORY

        Parameters
        ----------
        df : pandas.DataFrame
            DataFrame with training data containing at least *self.source_features* + optionally
            superfluously that will be ignored.

        """
        # prepare features
        source_dataframe = df[self.source_features]
        prep_feature_df = self._prep_feature_df(source_dataframe)

        self.final_features = prep_feature_df.columns
        prep_features = prep_feature_df.values

        # extract target variable
        target = df[self.target_variable].values

        # train
        self.model.fit(prep_features, target)

    def _prep_feature_df(self, df):
        """Executes the feature preparation in succession parsing a DataFrame between ich step.

        Parameters
        ----------
        df : pandas.DataFrame
            containing training or prediction.
        """
        df = df[self.source_features]

        df = replace_missing(df)
        df = replace_strings(df)

        data = add_polynomial(df, "sepalLength", "poly_sepalLength")
        return data
