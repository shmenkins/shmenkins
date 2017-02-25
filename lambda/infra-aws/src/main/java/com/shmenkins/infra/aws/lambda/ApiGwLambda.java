package com.shmenkins.infra.aws.lambda;

import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;

import com.shmenkins.core.handler.BasicHandler;

public abstract class ApiGwLambda<I, O> {

	static {
		// all logs from this instance can be identified using this value
		MDC.put("lambdaInstanceId", UUID.randomUUID().toString());
	}

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	private final BasicHandler<I, O> handler;

	protected ApiGwLambda(BasicHandler<I, O> handler) {
		this.handler = handler;
		log.info("Instantiated; handler={}", handler);
	}

	public O handle(I input) {

		log.debug("Handling; input={}", input);

		try {
			O output = handler.handle(input);
			log.debug("Handled; output={}", output);
			return output;
		} catch (Throwable e) {
			log.error("Cannot handle apigw request; input=" + input, e);
			throw new RuntimeException("500", e);
		}
	}

}
