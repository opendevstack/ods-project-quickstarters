import numpy as np


def add_polynomial(dataframe, input_col, output_col, power=2):
    dataframe[output_col] = np.power(dataframe[input_col].values, power)
    return dataframe
