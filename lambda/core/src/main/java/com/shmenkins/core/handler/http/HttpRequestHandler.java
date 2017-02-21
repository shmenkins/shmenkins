package com.shmenkins.core.handler.http;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.shmenkins.core.handler.BasicHandler;

public class HttpRequestHandler<O> implements BasicHandler<HttpRequest, O> {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	private final BasicHandler<HttpRequest, O> target;

	public HttpRequestHandler(BasicHandler<HttpRequest, O> target) {
		this.target = target;
	}

	@Override
	public O handle(HttpRequest request) {
		try {
			return target.handle(request);
		} catch (Throwable e) {
			log.error("Cannot handle apigw request; request=" + request, e);
			throw new RuntimeException("500", e);
		}
	}

}
