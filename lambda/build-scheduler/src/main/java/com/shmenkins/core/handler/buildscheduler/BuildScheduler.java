package com.shmenkins.core.handler.buildscheduler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.infra.notification.BuildScheduledEvent;
import com.shmenkins.core.infra.notification.RepoChangeEvent;
import com.shmenkins.core.infra.notification.Topic;

public class BuildScheduler implements BasicHandler<RepoChangeEvent, Void> {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	private final Topic<BuildScheduledEvent> buildScheduledTopic;

	public BuildScheduler(Topic<BuildScheduledEvent> buildScheduledTopic) {
		this.buildScheduledTopic = buildScheduledTopic;

		log.info("Instantiated;  topic={}", buildScheduledTopic);
	}

	@Override
	public Void handle(RepoChangeEvent repoChangeEvent) {

		log.debug("Scheduling build; repoUrl={}, headCommit={}", repoChangeEvent.repoUrl, repoChangeEvent.headCommit);

		BuildScheduledEvent buildScheduledEvent = new BuildScheduledEvent();
		buildScheduledEvent.repoChangeEvent = repoChangeEvent;
		buildScheduledTopic.publish(buildScheduledEvent);

		return null;
	}

}
