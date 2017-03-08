package com.shmenkins.infra.aws.lambda.builderlambda;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3Client;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.handler.builder.Builder;
import com.shmenkins.core.infra.binarystorage.BinaryStorage;
import com.shmenkins.core.infra.notification.BuildScheduledEvent;
import com.shmenkins.core.util.EnvUtils;
import com.shmenkins.infra.aws.binarystorage.BinaryStorageS3;
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
        String bucket = EnvUtils.getEnvOrFail("BUCKET");

        AmazonS3Client s3 = new AmazonS3Client().withRegion(Regions.fromName(region));

        BinaryStorage binStorage = new BinaryStorageS3(bucket, s3);

        // instantiation is allowed only here in lambda ctor
        // this is like spring context
        BasicHandler<BuildScheduledEvent, Void> handler = new Builder(binStorage);

        log.info("Instantiated; region={}, account={}", region, account);

        return handler;
    }

}
