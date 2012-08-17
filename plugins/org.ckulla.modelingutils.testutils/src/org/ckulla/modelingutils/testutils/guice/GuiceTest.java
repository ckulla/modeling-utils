package org.ckulla.modelingutils.testutils.guice;

import org.junit.Assert;
import org.junit.Rule;

public abstract class GuiceTest extends Assert {

	@Rule
	public GuiceRule guiceRule = new GuiceRule ();

}