package com.shmenkins.aws.lambda.webhookhandler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class WebhookHandler implements ApiGwReqeustHandler<Void> {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	// cache sns
	private final Sns sns;
	private final String topicName;

	public WebhookHandler(Sns sns, String topicName) {
		this.sns = sns;
		this.topicName = topicName;

		log.info("Instantiated;  sns={}, topicName={}", sns, topicName);
	}

	@Override
	public Void handle(ApiGwRequest request) {

		log.debug("Handling; topicName={}", topicName);

		sns.publish(topicName, "my-message");

		return null;
	}

}
