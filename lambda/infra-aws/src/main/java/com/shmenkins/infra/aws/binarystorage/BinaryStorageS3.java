package com.shmenkins.infra.aws.binarystorage;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.io.FileUtils;

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
    public InputStream getStream(String key) {
        return s3.getObject(new GetObjectRequest(bucketName, key)).getObjectContent();
    }

    @Override
    public File getFile(String key, String dest) {
        try {
            File file = new File(dest);
            FileUtils.copyInputStreamToFile(getStream(key), file);
            return file;
        } catch (IOException e) {
            throw new RuntimeException("Cannot download file from S3; src=" + key + ", dest=" + dest, e);
        }

    }

}
