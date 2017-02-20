package com.shmenkins.aws.lambda.webhookhandler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ErrorHandlingApiGwRequestHandler<O> implements ApiGwReqeustHandler<O> {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	private final ApiGwReqeustHandler<O> target;

	public ErrorHandlingApiGwRequestHandler(ApiGwReqeustHandler<O> target) {
		this.target = target;
	}

	@Override
	public O handle(ApiGwRequest request) {
		try {
			return target.handle(request);
		} catch (Throwable e) {
			log.error("Cannot handle apigw request; request=" + request, e);
			throw new RuntimeException("500");
		}
	}

}
