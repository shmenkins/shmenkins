package com.shmenkins.core.handler.http.webhookhandler;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.infra.notification.MBus;

public class WebhookHandler implements BasicHandler<Map<Object, Object>, Void> {

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
	public Void handle(Map<Object, Object> input) {

		log.debug("Handling; topicName={}", topicName);

		Json json = new Json(input);
		String repoUrl = json.get("body", "repository", "url");
		String headCommit = json.get("body", "after");
		log.debug("processing push; repoUrl={}, headCommit={}",repoUrl, headCommit);

		mBus.publish(topicName, "my-message");

		return null;
	}

	private static final class Json {
		private final Map<?, ?> root;

		public Json(Map<?, ?> obj) {
			this.root = obj;
		}

		@SuppressWarnings("unchecked")
		public <T> T get(String... path) {

			Object v = root;
			for (String pathElement : path) {
				v = ((Map<?, ?>) v).get(pathElement);
			}
			return (T) v;
		}
	}

}
