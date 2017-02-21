package com.shmenkins.core.handler.http.webhookhandler;

import org.mockito.Mockito;
import org.testng.annotations.Test;

import com.shmenkins.core.infra.notification.MBus;

public class WebhookHandlerTest {

	private final String topicName = "test-topic-name";

	@Test
	public void test() {
		// setup
		MBus mBus = Mockito.mock(MBus.class);

		// call
		new WebhookHandler(mBus, topicName).handle(null);

		// verify
		Mockito.verify(mBus).publish(topicName, "my-message");
	}
}
