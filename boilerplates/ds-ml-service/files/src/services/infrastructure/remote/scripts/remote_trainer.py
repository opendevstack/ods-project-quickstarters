"""
This file contains the script for executing the training in a remote machine
"""

if __name__ == '__main__':
    import argparse
    import os
    from services.infrastructure.logging import initialize_logging
    from model.trainer import train

    parser = argparse.ArgumentParser(description="Remote training script")
    parser.add_argument("--env", "-e", required=True, type=str, help="Environment folder/name")
    parser.add_argument("--debug", "-d", action="store_true", help="Enables debug mode")

    args = parser.parse_args()

    os.chdir(args.env)
    initialize_logging(path="training-remote.log", remote=True, debug=args.debug)
    train()
