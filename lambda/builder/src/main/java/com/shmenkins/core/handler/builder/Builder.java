package com.shmenkins.core.handler.builder;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.shmenkins.core.handler.BasicHandler;
import com.shmenkins.core.infra.binarystorage.BinaryStorage;
import com.shmenkins.core.infra.notification.BuildScheduledEvent;

import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.exception.ZipException;

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

            // download jdk (default jdk doesn't have javac)
            // java-1.8.0-openjdk-1.8.0.121-0.b13.29.amzn1.x86_64
            extractFromBinStorage("jdk.zip");
            new File("/tmp/java-1.8.0-openjdk-1.8.0.121-0.b13.29.amzn1.x86_64/bin/java").setExecutable(true);
            new File("/tmp/java-1.8.0-openjdk-1.8.0.121-0.b13.29.amzn1.x86_64/bin/javac").setExecutable(true);
            // download build tool
            extractFromBinStorage("apache-maven-3.3.9-bin.zip");
            new File("/tmp/apache-maven-3.3.9/bin/mvn").setExecutable(true);

            // build
            FileUtils.writeStringToFile(new File("/tmp/settings.xml"), settingsXml, StandardCharsets.UTF_8);

            ProcessBuilder pb = new ProcessBuilder("/tmp/apache-maven-3.3.9/bin/mvn", "-X", "--settings", "/tmp/settings.xml",
                    "clean", "verify");
            pb.directory(new File("/tmp/demo-simple-web-" + buildScheduledEvent.repoChangeEvent.headCommit));
            Map<String, String> env = pb.environment();
            // /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.121-0.b13.29.amzn1.x86_64/jre
            String javaHome = "/tmp/java-1.8.0-openjdk-1.8.0.121-0.b13.29.amzn1.x86_64";
            env.put("JAVA_HOME", javaHome);

            pb.redirectErrorStream(true);
            log.info("starting maven");
            Process p = pb.start();
            try (InputStream is = new BufferedInputStream(p.getInputStream())) {
                log.info("collecting maven output");
                String output = IOUtils.toString(is, StandardCharsets.UTF_8);
                log.info(output);

            }
            log.info("waiting for maven");
            int x = p.waitFor();
            log.info("maven exit value={}", x);
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
        }

        return null;
    }

    private void extractFromBinStorage(String fileName) throws ZipException {
        log.debug("downloading {}", fileName);
        File zip = binStorage.getFile(fileName, "/tmp/" + fileName);
        log.debug("extracting {}", fileName);
        new ZipFile(zip).extractAll("/tmp");
        log.debug("deleting archive {}", fileName);
        FileUtils.deleteQuietly(zip);
    }

    private final String settingsXml = "\n" + "\n" + "    <settings xmlns=\"http://maven.apache.org/SETTINGS/1.0.0\"\n"
            + "      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
            + "      xsi:schemaLocation=\"http://maven.apache.org/SETTINGS/1.0.0\n"
            + "                          https://maven.apache.org/xsd/settings-1.0.0.xsd\">\n"
            + "      <localRepository>}/tmp/.m2/repository</localRepository>\n"
            + "      <interactiveMode>false</interactiveMode>\n" + "    </settings>";

    public static void main(String[] args) {
        String javaHome = "blah/jre";
        javaHome = javaHome.substring(0, javaHome.length() - 4);
        System.out.println(javaHome);
    }

}
