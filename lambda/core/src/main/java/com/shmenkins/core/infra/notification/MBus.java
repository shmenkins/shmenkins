package com.shmenkins.core.infra.notification;

/**
 * Message bus.
 */
public interface MBus {

	public void publish(String topicName, String message);

}
