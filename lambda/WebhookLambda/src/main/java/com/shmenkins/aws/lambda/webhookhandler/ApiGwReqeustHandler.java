package com.shmenkins.aws.lambda.webhookhandler;

public interface ApiGwReqeustHandler<O> {

	O handle(ApiGwRequest request);
}
