package com.shmenkins.aws.lambda.webhooklambda;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.amazonaws.services.sns.AmazonSNSClient;
import com.shmenkins.aws.lambda.webhookhandler.ApiGwReqeustHandler;
import com.shmenkins.aws.lambda.webhookhandler.ApiGwRequest;
import com.shmenkins.aws.lambda.webhookhandler.BasicLambda;
import com.shmenkins.aws.lambda.webhookhandler.EnvUtils;
import com.shmenkins.aws.lambda.webhookhandler.ErrorHandlingApiGwRequestHandler;
import com.shmenkins.aws.lambda.webhookhandler.Sns;
import com.shmenkins.aws.lambda.webhookhandler.WebhookHandler;

// this class is like a spring context
// instantiation happens here
// that's the only responsibility of this class
public class WebhookLambda extends BasicLambda implements ApiGwReqeustHandler<Void> {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	// cache handler
	private final ApiGwReqeustHandler<Void> handler;

	public WebhookLambda() {

		// all dependencies (env variables) are explicit and in one place
		String region = EnvUtils.getEnvOrFail("AWS_REGION");
		String account = EnvUtils.getEnvOrFail("AWS_ACCOUNT");
		String topicName = EnvUtils.getEnvOrFail("TOPIC_NAME");

		// instantiation is allowed only here in lambda ctor
		// this is like spring context
		Sns sns = new Sns(new AmazonSNSClient(), region, account);

		this.handler = new ErrorHandlingApiGwRequestHandler<>(new WebhookHandler(sns, topicName));

		log.info("Instantiated; region={}, account={}, topicName={}", region, account, topicName);
	}

	public Void handle(ApiGwRequest request) {

		log.debug("Handling; request={}", request);

		return handler.handle(request);
	}

}
