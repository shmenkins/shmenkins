package com.shmenkins.core.handler.http.webhookhandler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.handler.http.HttpRequest;
import com.shmenkins.core.infra.notification.MBus;

public class WebhookHandler implements BasicHandler<HttpRequest, Void> {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	// cache mBus
	private final MBus mBus;
	private final String topicName;

	public WebhookHandler(MBus mBus, String topicName) {
		this.mBus = mBus;
		this.topicName = topicName;

		log.info("Instantiated;  mBus={}, topicName={}", mBus, topicName);
	}

	@Override
	public Void handle(HttpRequest request) {

		log.debug("Handling; topicName={}", topicName);

		mBus.publish(topicName, "my-message");

		return null;
	}

}
