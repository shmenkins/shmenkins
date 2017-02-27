package com.shmenkins.infra.aws.lambda.builderlambda;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.handler.builder.Builder;
import com.shmenkins.core.infra.notification.BuildScheduledEvent;
import com.shmenkins.core.util.EnvUtils;
import com.shmenkins.infra.aws.lambda.SnsLambda;

// this class is like a spring context
// instantiation happens here
// that's the only responsibility of this class
public class BuilderLambda extends SnsLambda<BuildScheduledEvent> {

	private static final Logger log = LoggerFactory.getLogger(BuilderLambda.class);

	private static final ObjectMapper mapper = createObjectMapper();

	public BuilderLambda() {
		super(createHandler(), mapper, BuildScheduledEvent.class);
	}

	private static ObjectMapper createObjectMapper() {
		ObjectMapper mapper = new ObjectMapper();
		mapper.setSerializationInclusion(Include.NON_EMPTY);
		return mapper;
	}

	private static BasicHandler<BuildScheduledEvent, Void> createHandler() {
		// all dependencies (env variables) are explicit and in one place
		String region = EnvUtils.getEnvOrFail("AWS_REGION");
		String account = EnvUtils.getEnvOrFail("AWS_ACCOUNT");

		// instantiation is allowed only here in lambda ctor
		// this is like spring context
		BasicHandler<BuildScheduledEvent, Void> handler = new Builder();

		log.info("Instantiated; region={}, account={}", region, account);

		return handler;
	}

}
