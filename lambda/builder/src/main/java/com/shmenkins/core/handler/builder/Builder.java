package com.shmenkins.core.handler.builder;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.infra.binarystorage.BinaryStorage;
import com.shmenkins.core.infra.notification.BuildScheduledEvent;
import com.shmenkins.core.infra.notification.RepoChangeEvent;

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
//            FileUtils.deleteQuietly(zipFile);
            // unzip(zipFile, destDir);

            // download build tool
            log.debug("Getting maven source code; file={}", zipFile);
            File mavenZip = binStorage.getFile("apache-maven-3.3.9-bin.zip", "/tmp/apache-maven-3.3.9-bin.zip");
            log.debug("extracting maven source code; file={}", mavenZip);
            new ZipFile(mavenZip).extractAll("/tmp");
//            FileUtils.deleteQuietly(mavenZip);

            // extract

            // build
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
        }

        return null;
    }

    private void unzip(String zip, String destDir) {
        try {
            byte[] buffer = new byte[1024];
            ZipInputStream zis = new ZipInputStream(new FileInputStream(zip));
            try {
                ZipEntry zipEntry;
                while ((zipEntry = zis.getNextEntry()) != null) {
                    String fileName = zipEntry.getName();
                    log.debug("Extracting {}", fileName);
                    File newFile = new File(destDir + "/" + fileName);
                    if (zipEntry.isDirectory()) {
                        newFile.mkdirs();
                    } else {
                        File parent = newFile.getParentFile();
                        if (parent != null) {
                            parent.mkdirs();
                        }
                        try (FileOutputStream fos = new FileOutputStream(newFile)) {
                            int len;
                            while ((len = zis.read(buffer)) > 0) {
                                fos.write(buffer, 0, len);
                            }
                        }
                    }
                }
            } finally {
                zis.closeEntry();
                zis.close();
            }
        } catch (Exception e) {
            throw new RuntimeException("Cannot unpack zip; zipFile=" + zip, e);
        }
    }

    private void downloadFile(String url, String dest) {
        try (InputStream is = new URL(url).openStream()) {
            try (ReadableByteChannel rbc = Channels.newChannel(is)) {
                try (FileOutputStream fos = new FileOutputStream(dest)) {
                    fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Cannot download a file; url=" + url, e);
        }
    }

    public static void main(String[] args) {
        BuildScheduledEvent e = new BuildScheduledEvent();
        e.repoChangeEvent = new RepoChangeEvent();
        e.repoChangeEvent.headCommit = "9c5951a2face816006be6bca218ef0cbfa322b10";
        e.repoChangeEvent.repoUrl = "https://github.com/rzhilkibaev/demo-simple-web";
    }

}
