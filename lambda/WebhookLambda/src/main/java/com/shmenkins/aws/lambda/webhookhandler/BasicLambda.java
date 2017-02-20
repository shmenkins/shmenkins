package com.shmenkins.aws.lambda.webhookhandler;

import java.util.UUID;

import org.slf4j.MDC;

public class BasicLambda {

	protected BasicLambda() {
		// all logs from this instance are tied with this value
		MDC.put("lambdaInstanceId", UUID.randomUUID().toString());
	}
}
