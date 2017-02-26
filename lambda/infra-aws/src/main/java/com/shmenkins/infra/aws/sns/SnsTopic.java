package com.shmenkins.infra.aws.sns;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shmenkins.core.infra.notification.Topic;

public class SnsTopic<T> implements Topic<T> {

	private final String topicName;
	private final Sns sns;
	private final ObjectMapper mapper;

	public SnsTopic(String topicName, Sns sns, ObjectMapper mapper) {
		this.topicName = topicName;
		this.sns = sns;
		this.mapper = mapper;
	}

	@Override
	public void publish(T obj) {
		String message;
		try {
			message = mapper.writeValueAsString(obj);
		} catch (JsonProcessingException e) {
			throw new IllegalArgumentException("Cannot parse object; obj=" + obj, e);
		}
		sns.publish(topicName, message);
	}
}
