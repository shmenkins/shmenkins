package com.shmenkins.core.infra.binarystorage;

import java.io.InputStream;

public interface BinaryStorage {

	InputStream get(String key);
}
