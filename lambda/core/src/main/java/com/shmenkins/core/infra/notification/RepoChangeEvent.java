package com.shmenkins.core.infra.notification;

public class RepoChangeEvent {
	public String repoUrl;
	public String headCommit;

	@Override
	public String toString() {
		return "RepoChangeEvent {repoUrl=" + repoUrl + ", headCommit=" + headCommit + "}";
	}

}
