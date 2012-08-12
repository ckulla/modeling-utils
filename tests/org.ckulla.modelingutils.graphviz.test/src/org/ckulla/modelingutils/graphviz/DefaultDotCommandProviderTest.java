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
	public void testRunCommand () throws IOException, InterruptedException {
		DefaultDotCommandProvider cp = new DefaultDotCommandProvider();
		assertEquals ("dot - graphviz version 2.26.3 (20100126.1600)\n", cp.runCommand("/usr/local/bin/dot" , "-V"));
	}

	@Test
	public void testHasDot () throws IOException, InterruptedException {
		DefaultDotCommandProvider cp = new DefaultDotCommandProvider();
		assertTrue (cp.hasDot("/usr/local/bin/dot"));
	}

	@Test
	public void getDotCommand () throws IOException, InterruptedException {
		DefaultDotCommandProvider cp = new DefaultDotCommandProvider();
		assertEquals ("/usr/local/bin/dot", cp.getDotCommand());
	}

}
