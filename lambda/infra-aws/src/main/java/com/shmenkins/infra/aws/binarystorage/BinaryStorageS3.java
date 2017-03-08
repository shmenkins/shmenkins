package com.shmenkins.infra.aws.binarystorage;

import java.io.InputStream;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.shmenkins.core.infra.binarystorage.BinaryStorage;

public class BinaryStorageS3 implements BinaryStorage {

	private final String bucketName;
	private final AmazonS3 s3;

	public BinaryStorageS3(String bucketName, AmazonS3 s3) {
		this.s3 = s3;
		this.bucketName = bucketName;
	}

	@Override
	public InputStream get(String key) {
		return s3.getObject(new GetObjectRequest(bucketName, key)).getObjectContent();
	}

}
