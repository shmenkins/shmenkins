package com.shmenkins.infra.aws.lambda;

import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;

import com.shmenkins.core.handler.BasicHandler;

public abstract class BasicLambda<I, O> {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	private final BasicHandler<I, O> handler;

	protected BasicLambda(BasicHandler<I, O> handler) {
		// all logs from this instance can be identified using this value
		MDC.put("lambdaInstanceId", UUID.randomUUID().toString());

		this.handler = handler;

		log.info("Instantiated; handler={}", handler);
	}

	public O handle(I request) {

		log.debug("Handling; request={}", request);

		return handler.handle(request);
	}

}
