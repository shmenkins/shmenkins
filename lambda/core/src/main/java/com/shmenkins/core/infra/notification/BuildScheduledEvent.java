package com.shmenkins.core.infra.notification;

public class BuildScheduledEvent {

	public RepoChangeEvent repoChangeEvent;

	@Override
	public String toString() {
		return "BuildScheduledEvent {repoChangeEvent=" + repoChangeEvent + "}";
	}

}
