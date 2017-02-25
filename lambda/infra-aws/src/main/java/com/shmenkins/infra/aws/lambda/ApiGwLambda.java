package com.shmenkins.infra.aws.lambda;

import java.util.Collections;
import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;

import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.handler.http.HttpRequest;
import com.shmenkins.core.handler.http.HttpResponse;

public abstract class ApiGwLambda {

	static {
		// all logs from this instance can be identified using this value
		MDC.put("lambdaInstanceId", UUID.randomUUID().toString());
	}

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	private final BasicHandler<HttpRequest, HttpResponse> handler;

	protected ApiGwLambda(BasicHandler<HttpRequest, HttpResponse> handler) {
		this.handler = handler;
		log.info("Instantiated; handler={}", handler);
	}

	public Map<Object, Object> handle(Map<Object, Object> apiGwRequest) {

		log.debug("Handling; request={}", apiGwRequest);

		HttpRequest httpRequest = apiGwToHttpRequest(apiGwRequest);

		try {
			HttpResponse httpResponse = handler.handle(httpRequest);
			Map<Object, Object> apiGwResponse = httpToApiGwResponse(httpResponse);
			return apiGwResponse;
		} catch (Throwable e) {
			log.error("Cannot handle apigw request; request=" + apiGwRequest, e);
			throw new RuntimeException("500", e);
		}
	}

	private HttpRequest apiGwToHttpRequest(Map<Object, Object> apiGwRequest) {
		log.trace("ApiGwRequest={}", apiGwRequest);
		return new HttpRequest();
	}

	private Map<Object, Object> httpToApiGwResponse(HttpResponse httpResponse) {
		return Collections.emptyMap();
	}
	
}
