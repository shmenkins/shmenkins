package com.shmenkins.core.util;

public class EnvUtils {

	public static String getEnvOrFail(String name) {
		return nvl(System.getenv(name), new IllegalStateException("Environment variable " + name + " not set"));
	}

	public static <T> T nvl(T value, RuntimeException exc) {
		if (value == null) {
			throw exc;
		}

		return value;
	}

	private EnvUtils() {
	}

}
