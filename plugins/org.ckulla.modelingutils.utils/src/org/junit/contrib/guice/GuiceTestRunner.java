package org.junit.contrib.guice;

import org.junit.contrib.rules.RulesTestRunner;
import org.junit.runners.model.InitializationError;

public class GuiceTestRunner extends RulesTestRunner {

	public GuiceTestRunner(Class<?> klass) throws InitializationError {
		super (klass, new GuiceRule ());
	}

}
