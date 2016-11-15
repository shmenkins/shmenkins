import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handle_request(event, context):
    logger.info('got event {}'.format(event))
    logger.error('something went wrong')
    return 'Hello World!' 
