package org.ckulla.modelingutils.testutils.guice;

import org.ckulla.modelingutils.testutils.rules.RulesTestRunner;
import org.junit.runners.model.InitializationError;

public class GuiceTestRunner extends RulesTestRunner {

	public GuiceTestRunner(Class<?> klass) throws InitializationError {
		super (klass, new GuiceRule ());
	}

}
