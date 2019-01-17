from sklearn.linear_model import LogisticRegression

from model.data_cleaning.replace import replace_strings, replace_missing
from model.feature_prep.polynomial import add_polynomial


class ClassificationModel(object):

    def __init__(self):
        self.model = LogisticRegression()
        self.source_features = ["sepalLength", "sepalWidth", "petalWidth"]
        self.target_variable = "Species"
        self.final_features = []

    def prep_and_predict(self, df):
        # restrict to known source features
        df = df[self.source_features]

        # find all not used source features
        not_used_source = df[df.columns.difference(self.source_features)].columns.values.tolist()
        if not_used_source:
            print("Warning: Features: {} are not being used but given".format(not_used_source))

        # feature preparation
        prep_data_df = self.prep_feature_df(df)
        prep_data = prep_data_df.values

        res = self.model.predict(prep_data).tolist()[0]
        return res

    def prep_train(self, df):
        # prepare features
        source_dataframe = df[self.source_features]
        prep_feature_df = self.prep_feature_df(source_dataframe)

        self.final_features = prep_feature_df.columns
        prep_features = prep_feature_df.values

        # extract target variable
        target = df[self.target_variable].values

        # train
        self.model.fit(prep_features, target)

    def prep_feature_df(self, df):
        df = df[self.source_features]

        df = replace_missing(df)
        df = replace_strings(df)

        data = add_polynomial(df, "sepalLength", "poly_sepalLength")
        return data
