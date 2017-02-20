package com.shmenkins.aws.lambda.webhookhandler;

import org.mockito.Mockito;
import org.testng.annotations.Test;

public class WebhookHandlerTest {

	private final String topicName = "test-topic-name";

	@Test
	public void test() {
		// setup
		Sns sns = Mockito.mock(Sns.class);

		// call
		new WebhookHandler(sns, topicName).handle(null);
		
		// verify
		Mockito.verify(sns).publish(topicName, "my-message");
	}
}
