import logging
import os
from typing import Optional

from services.infrastructure.environment import debug_mode

log_path = None


class FileHandlerFilter(logging.Filter):
    def filter(self, record: logging.LogRecord) -> bool:
        return not record.name.startswith(('flask', 'werkzeug'))


def initialize_logging(path, debug=debug_mode(), remote=False):
    global log_path

    log_path = path

    log_formatter = logging.Formatter(
        "{0}%(asctime)s [%(name)-15.15s] [%(levelname)-5.5s]  %(message)s".format("|REMOTE| " if remote else ""))
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.DEBUG if debug else logging.INFO)

    console_handler = logging.StreamHandler()
    console_handler.setFormatter(log_formatter)
    console_handler.setLevel(logging.DEBUG if debug else logging.INFO)
    root_logger.addHandler(console_handler)

    file_handler = logging.FileHandler(path)
    file_handler.setFormatter(log_formatter)
    file_handler.setLevel(logging.DEBUG)
    file_handler.addFilter(FileHandlerFilter())
    root_logger.addHandler(file_handler)


def read_log() -> Optional[str]:
    global log_path

    if os.path.exists(log_path):
        with open(log_path, 'r') as file:
            return file.read()
    else:
        return None
