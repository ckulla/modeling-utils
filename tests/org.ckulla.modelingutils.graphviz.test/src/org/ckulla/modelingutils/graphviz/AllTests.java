package org.ckulla.modelingutils.graphviz;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

@RunWith(Suite.class)
@SuiteClasses({
	FooTest.class,
	EcoreTest.class,
	RunDotTest.class,
	EcoreToDotGeneratorTest.class,
	EnumerationTest.class,
	CollapseGraphTest.class,
	DefaultDotCommandProviderTest.class,
	DataTypeTest.class
	})
public class AllTests {

}
