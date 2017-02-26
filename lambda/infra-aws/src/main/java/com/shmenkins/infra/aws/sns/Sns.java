package com.shmenkins.infra.aws.sns;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.amazonaws.services.sns.AmazonSNSClient;

public class Sns {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	private final AmazonSNSClient snsClient;
	private final String region;
	private final String account;

	public Sns(AmazonSNSClient snsClient, String region, String account) {
		this.snsClient = snsClient;
		this.region = region;
		this.account = account;

		log.info("Instantiated; region={}, account={}", region, account);
	}

	public void publish(String topicName, String message) {
		String topicArn = getTopicArn(topicName);

		log.debug("Publishing to topic; topicArn={}", topicArn);

		snsClient.publish(topicArn, message);

		log.debug("Published to topic; topicArn={}", topicArn);
	}

	private String getTopicArn(String topicName) {
		// arn:aws:sns:us-east-1:123456789012:my_topic
		return "arn:aws:sns:" + region + ":" + account + ":" + topicName;
	}

	@Override
	public String toString() {
		return this.getClass().getSimpleName() + ": {" + region + ":" + account + "}";
	}
}
