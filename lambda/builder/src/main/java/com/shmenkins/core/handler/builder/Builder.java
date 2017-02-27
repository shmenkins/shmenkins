package com.shmenkins.core.handler.builder;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.infra.notification.BuildScheduledEvent;

public class Builder implements BasicHandler<BuildScheduledEvent, Void> {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	public Builder() {
		log.info("Instantiated");
	}

	@Override
	public Void handle(BuildScheduledEvent buildScheduledEvent) {

		log.debug("Building; buildScheduledEvent={}", buildScheduledEvent);

		return null;
	}

}
