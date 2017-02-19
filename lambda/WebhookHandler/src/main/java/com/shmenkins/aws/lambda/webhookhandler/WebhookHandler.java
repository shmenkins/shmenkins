package com.shmenkins.aws.lambda.webhookhandler;

import java.util.Map;

import com.google.common.collect.ImmutableList;

public class WebhookHandler {

	public void handle(Map<String, Object> request) {
		System.out.println("hi");
		System.out.println(ImmutableList.class.getName());
	}
}
