package com.shmenkins.infra.aws.lambda;

import java.io.IOException;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;

import com.amazonaws.services.lambda.runtime.events.SNSEvent;
import com.amazonaws.services.lambda.runtime.events.SNSEvent.SNSRecord;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shmenkins.core.handler.BasicHandler;

public class SnsLambda<E> {

	static {
		// all logs from this instance can be identified using this value
		MDC.put("lambdaInstanceId", UUID.randomUUID().toString());
	}

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	private final BasicHandler<E, Void> handler;

	private final ObjectMapper mapper;

	private final Class<E> type;

	protected SnsLambda(BasicHandler<E, Void> handler, ObjectMapper mapper, Class<E> type) {
		this.handler = handler;
		this.mapper = mapper;
		this.type = type;
		log.info("Instantiated; handler={}", handler);
	}

	public void handle(SNSEvent snsEvent) {
		log.debug("Handling; records={}", snsEvent.getRecords().size());

		for (SNSRecord record : snsEvent.getRecords()) {
			log.debug("Handling sns record; messageId={}", record.getSNS().getMessageId());
			String message = record.getSNS().getMessage();
			try {
				E event = mapper.readValue(message, type);
				handler.handle(event);
				log.debug("Handled sns record; messageId={}", record.getSNS().getMessageId());
			} catch (IOException e) {
				// don't break the loop
				log.error("Cannot deserialize sns message; message={}, type={}", message, type.getName());
			}
		}
		log.debug("Handled");
	}

}
