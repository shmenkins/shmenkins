import logging
import os


def get_logger() -> logging.Logger:
    """ Returns a logger with a log level
        taken from LOG_LEVEL environment variable.
        If the variable is not set then INFO level is used."""

    log_level = os.environ.get("LOG_LEVEL")  # type: str

    if log_level is None:
        log_level = "INFO"

    logger = logging.getLogger()
    logger.setLevel(log_level)
    return logger
