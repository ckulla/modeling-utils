package org.ckulla.xtend2utils.emffactory;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

@RunWith(Suite.class)
@SuiteClasses({ 
	FactoryGeneratorTest.class,
	Mwe2ExecutionTest.class,
	ImportManagerTest.class,
	XtendImportManagerTest.class
})
public class AllTests {

}
