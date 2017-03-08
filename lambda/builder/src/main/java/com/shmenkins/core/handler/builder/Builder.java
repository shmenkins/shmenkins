package com.shmenkins.core.handler.builder;

import java.io.File;
import java.net.URL;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.infra.binarystorage.BinaryStorage;
import com.shmenkins.core.infra.notification.BuildScheduledEvent;

import net.lingala.zip4j.core.ZipFile;

public class Builder implements BasicHandler<BuildScheduledEvent, Void> {

    private final Logger log = LoggerFactory.getLogger(this.getClass());

    private final BinaryStorage binStorage;

    public Builder(BinaryStorage binStorage) {
        this.binStorage = binStorage;
        log.info("Instantiated");
    }

    @Override
    public Void handle(BuildScheduledEvent buildScheduledEvent) {

        log.debug("Building; buildScheduledEvent={}", buildScheduledEvent);

        try {
            // download source code zip
            // https://github.com/{username}/{projectname}/archive/{sha}.zip
            String zipUrl = buildScheduledEvent.repoChangeEvent.repoUrl + "/archive/"
                    + buildScheduledEvent.repoChangeEvent.headCommit + ".zip";
            File zipFile = new File("/tmp/" + buildScheduledEvent.repoChangeEvent.headCommit + ".zip");
            log.debug("Downloading source code; url={}", zipUrl);

            FileUtils.copyURLToFile(new URL(zipUrl), zipFile);

            log.debug("Downloaded source code; url={}", zipUrl);
            // extract
            String destDir = "/tmp";
            log.debug("Extracting source code; file={}", zipFile);
            new ZipFile(zipFile).extractAll(destDir);
            FileUtils.deleteQuietly(zipFile);

            // download build tool
            log.debug("Getting maven source code; file={}", zipFile);
            File mavenZip = binStorage.getFile("apache-maven-3.3.9-bin.zip", "/tmp/apache-maven-3.3.9-bin.zip");
            log.debug("extracting maven source code; file={}", mavenZip);
            FileUtils.deleteQuietly(mavenZip);
            // extract
            new ZipFile(mavenZip).extractAll("/tmp");

            // build
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
        }

        return null;
    }

}
