package org.ckulla.modelingutils.graphviz;

import static org.junit.Assert.*;

import java.io.IOException;

import org.junit.Test;

public class DefaultDotCommandProviderTest {

	@Test
	public void testConcatPaths () {
		DefaultDotCommandProvider cp = new DefaultDotCommandProvider();
		assertEquals ("a/b",cp.concatPaths("a", "b"));
		assertEquals ("a/b",cp.concatPaths("a/", "b"));
		assertEquals ("a/b",cp.concatPaths("a", "/b"));
		assertEquals ("a/b",cp.concatPaths("a\\", "b"));
		assertEquals ("a/b",cp.concatPaths("a", "\\b"));
		assertEquals ("a/b",cp.concatPaths("a\\", "\\b"));
	}
	
	@Test
	public void getDotCommand () throws IOException, InterruptedException {
		DefaultDotCommandProvider cp = new DefaultDotCommandProvider();
		assertTrue (cp.getDotCommand().get(0).length() > 0);
	}

}
