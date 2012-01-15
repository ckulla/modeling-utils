package org.eclipse.emf.visualization.graphviz;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

@RunWith(Suite.class)
@SuiteClasses({
	FooTest.class,
	EcoreTest.class,
	RunDotTest.class
	})
public class AllTests {

}
