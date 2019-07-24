import argparse
import json
import traceback

import joblib

if __name__ == '__main__':
    model = joblib.load("local.model")

    parser = argparse.ArgumentParser(description="Predict command line")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--data", "-d", type=str,
                       help="Json string containing the data for prediction")
    group.add_argument("--input-file", "-f", type=str, dest="input_file",
                       help="Json file containing the data for prediction")

    args = parser.parse_args()


    if args.data:
        data = json.loads(args.data)
    else:
        data = json.load(
            open(args.input_file)
        )
    try:
        res = model.prep_and_predict(data)
        print(
            json.dumps(res, indent=True, sort_keys=True)
        )
    except:
        print("Input data:")
        print(args.data)
        print("Parsed input data:")
        print(data)
        traceback.print_exc()


