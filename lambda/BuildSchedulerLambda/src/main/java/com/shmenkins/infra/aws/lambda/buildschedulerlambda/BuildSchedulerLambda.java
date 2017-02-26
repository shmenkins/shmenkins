package com.shmenkins.infra.aws.lambda.buildschedulerlambda;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.sns.AmazonSNSClient;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.handler.buildscheduler.BuildScheduler;
import com.shmenkins.core.infra.notification.BuildScheduledEvent;
import com.shmenkins.core.infra.notification.RepoChangeEvent;
import com.shmenkins.core.infra.notification.Topic;
import com.shmenkins.core.util.EnvUtils;
import com.shmenkins.infra.aws.lambda.SnsLambda;
import com.shmenkins.infra.aws.sns.Sns;
import com.shmenkins.infra.aws.sns.SnsTopic;

// this class is like a spring context
// instantiation happens here
// that's the only responsibility of this class
public class BuildSchedulerLambda extends SnsLambda<RepoChangeEvent> {

	private static final Logger log = LoggerFactory.getLogger(BuildSchedulerLambda.class);

	private static final ObjectMapper mapper = createObjectMapper();

	public BuildSchedulerLambda() {
		super(createHandler(), mapper, RepoChangeEvent.class);
	}

	private static ObjectMapper createObjectMapper() {
		ObjectMapper mapper = new ObjectMapper();
		mapper.setSerializationInclusion(Include.NON_EMPTY);
		return mapper;
	}

	private static BasicHandler<RepoChangeEvent, Void> createHandler() {
		// all dependencies (env variables) are explicit and in one place
		String region = EnvUtils.getEnvOrFail("AWS_REGION");
		String account = EnvUtils.getEnvOrFail("AWS_ACCOUNT");
		String topicName = EnvUtils.getEnvOrFail("TOPIC_NAME");

		// instantiation is allowed only here in lambda ctor
		// this is like spring context

		// have to set region for sns client here, otherwise uses default one
		Sns sns = new Sns(new AmazonSNSClient().withRegion(Regions.fromName(region)), region, account);
		Topic<BuildScheduledEvent> topic = new SnsTopic<>(topicName, sns, mapper);

		BasicHandler<RepoChangeEvent, Void> handler = new BuildScheduler(topic);

		log.info("Instantiated; region={}, account={}, topicName={}", region, account, topicName);

		return handler;
	}

}
