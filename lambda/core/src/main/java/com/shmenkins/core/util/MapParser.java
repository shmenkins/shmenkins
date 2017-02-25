package com.shmenkins.core.util;

import java.util.Map;

public final class MapParser {

	private final Map<?, ?> root;

	public MapParser(Map<?, ?> obj) {
		this.root = obj;
	}

	@SuppressWarnings("unchecked")
	public <T> T get(String... path) {

		Object v = root;
		for (String pathElement : path) {
			v = ((Map<?, ?>) v).get(pathElement);
		}
		return (T) v;
	}
}
