import os
from typing import Optional

DSI_SSH_HTTPS_PROXY = "DSI_SSH_HTTPS_PROXY"

DSI_SSH_HTTP_PROXY = "DSI_SSH_HTTP_PROXY"

DSI_DEBUG_MODE = "DSI_DEBUG_MODE"
DSI_PACKAGE = "DSI_PACKAGE"

DSI_SSH_PASSWORD = "DSI_SSH_PASSWORD"
DSI_SSH_USERNAME = "DSI_SSH_USERNAME"
DSI_SSH_HOST = "DSI_SSH_HOST"
DSI_SSH_PORT = "DSI_SSH_PORT"

DSI_EXECUTE_ON = "DSI_EXECUTE_ON"
DSI_EXECUTE_ON_LOCAL = "LOCAL"
DSI_EXECUTE_ON_SSH = "SSH"

NEXUS_USERNAME = "NEXUS_USERNAME"
NEXUS_PASSWORD = "NEXUS_PASSWORD"
NEXUS_URL = "NEXUS_URL"
DSI_TRAINING_BASE_URL = "DSI_TRAINING_BASE_URL"

DSI_TRAINING_SERVICE_USERNAME = "DSI_TRAINING_SERVICE_USERNAME"
DSI_TRAINING_SERVICE_PASSWORD = "DSI_TRAINING_SERVICE_PASSWORD"
DSI_PREDICTION_SERVICE_USERNAME = "DSI_PREDICTION_SERVICE_USERNAME"
DSI_PREDICTION_SERVICE_PASSWORD = "DSI_PREDICTION_SERVICE_PASSWORD"


def debug_mode() -> bool:
    return os.getenv(DSI_DEBUG_MODE, "false").lower() in ["true",
                                                          "1",
                                                          "yes"]


def execution_environment() -> str:
    return os.getenv(DSI_EXECUTE_ON, DSI_EXECUTE_ON_LOCAL).upper()


def ssh_host() -> Optional[str]:
    return os.getenv(DSI_SSH_HOST)


def ssh_username() -> Optional[str]:
    return os.getenv(DSI_SSH_USERNAME)


def ssh_password() -> Optional[str]:
    return os.getenv(DSI_SSH_PASSWORD)


def ssh_port() -> int:
    return int(os.getenv(DSI_SSH_PORT, "22"))


def dsi_package() -> Optional[str]:
    return os.getenv(DSI_PACKAGE)


def http_proxy() -> Optional[str]:
    return os.getenv(DSI_SSH_HTTP_PROXY)


def https_proxy() -> Optional[str]:
    return os.getenv(DSI_SSH_HTTPS_PROXY)


def nexus_env() -> (Optional[str], Optional[str], Optional[str]):
    return os.getenv(NEXUS_URL), os.getenv(NEXUS_USERNAME), os.getenv(NEXUS_PASSWORD)


def training_host_url() -> str:
    return os.getenv(DSI_TRAINING_BASE_URL, "http://training:8080")


def training_auth(raiseException: bool = True) -> dict:
    return _auth(DSI_TRAINING_SERVICE_USERNAME, DSI_TRAINING_SERVICE_PASSWORD, raiseException)


def _auth(username_key, password_key, raiseException: bool = True) -> Optional[dict]:
    user = os.getenv(username_key)
    password = os.getenv(password_key)

    if not user or not password:
        if raiseException:
            raise Exception("{0} and/or {1} environment variables are not set".format(username_key,
                                                                                      password_key))
        else:
            return None
    return {
        user: password
    }


def prediction_auth(raiseException: bool = True) -> dict:
    return _auth(DSI_PREDICTION_SERVICE_USERNAME, DSI_PREDICTION_SERVICE_PASSWORD, raiseException)
