package com.shmenkins.infra.aws.lambda.webhooklambda;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.sns.AmazonSNSClient;
import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.handler.http.webhookhandler.WebhookHandler;
import com.shmenkins.core.util.EnvUtils;
import com.shmenkins.infra.aws.lambda.ApiGwLambda;
import com.shmenkins.infra.aws.sns.Sns;

// this class is like a spring context
// instantiation happens here
// that's the only responsibility of this class
public class WebhookLambda extends ApiGwLambda<Map<Object, Object>, Void> {

	private static final Logger log = LoggerFactory.getLogger(WebhookLambda.class);

	public WebhookLambda() {
		super(createHandler());
	}

	private static BasicHandler<Map<Object, Object>, Void> createHandler() {
		// all dependencies (env variables) are explicit and in one place
		String region = EnvUtils.getEnvOrFail("AWS_REGION");
		String account = EnvUtils.getEnvOrFail("AWS_ACCOUNT");
		String topicName = EnvUtils.getEnvOrFail("TOPIC_NAME");

		// instantiation is allowed only here in lambda ctor
		// this is like spring context

		// have to set region for sns client here, otherwise uses default one
		Sns sns = new Sns(new AmazonSNSClient().withRegion(Regions.fromName(region)), region, account);

		BasicHandler<Map<Object, Object>, Void> handler = new WebhookHandler(sns, topicName);

		log.info("Instantiated; region={}, account={}, topicName={}", region, account, topicName);

		return handler;
	}

}
