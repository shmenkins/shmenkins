package com.shmenkins.core.handler.http.webhookhandler;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.infra.notification.RepoChangeEvent;
import com.shmenkins.core.infra.notification.Topic;
import com.shmenkins.core.util.MapParser;

public class WebhookHandler implements BasicHandler<Map<Object, Object>, Void> {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	private final Topic<RepoChangeEvent> repoChangeTopic;

	public WebhookHandler(Topic<RepoChangeEvent> repoChangeTopic) {
		this.repoChangeTopic = repoChangeTopic;

		log.info("Instantiated;  topic={}", repoChangeTopic);
	}

	@Override
	public Void handle(Map<Object, Object> input) {

		log.debug("Handling; topic={}", repoChangeTopic);

		MapParser json = new MapParser(input);
		RepoChangeEvent repoChangeEvent = new RepoChangeEvent();
		repoChangeEvent.repoUrl = json.get("body", "repository", "url");
		repoChangeEvent.headCommit = json.get("body", "after");

		log.debug("processing push; repoUrl={}, headCommit={}", repoChangeEvent.repoUrl, repoChangeEvent.headCommit);

		repoChangeTopic.publish(repoChangeEvent);

		return null;
	}

}
