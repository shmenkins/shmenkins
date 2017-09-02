from shmenkins.utils import logging

def test_dummy():
    logger = logging.get_logger()
    assert logger is not None
    
