def replace_missing(dataframe):
    return dataframe.fillna(0)


def replace_strings(dataframe):
    return dataframe.replace("xx", 0)
