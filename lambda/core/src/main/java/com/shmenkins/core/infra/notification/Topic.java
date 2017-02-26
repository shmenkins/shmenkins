package com.shmenkins.core.infra.notification;

/**
 * Message bus topic.
 */
public interface Topic<T> {

	public void publish(T obj);

}
