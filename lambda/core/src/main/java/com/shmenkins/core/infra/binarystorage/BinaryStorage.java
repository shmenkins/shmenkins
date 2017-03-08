package com.shmenkins.core.infra.binarystorage;

import java.io.File;
import java.io.InputStream;

public interface BinaryStorage {

    InputStream getStream(String key);

    File getFile(String key, String file);
}
