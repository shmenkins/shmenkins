package com.shmenkins.core.handler;

public interface BasicHandler<I, O> {

	O handle(I input);

}
