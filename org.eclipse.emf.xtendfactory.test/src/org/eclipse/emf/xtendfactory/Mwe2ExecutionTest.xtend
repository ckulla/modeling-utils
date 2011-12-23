package org.eclipse.emf.xtendfactory

import org.junit.Test
import org.eclipse.emf.mwe2.launch.runtime.Mwe2Launcher
import java.io.File
import org.junit.After

import static org.junit.Assert.*

class Mwe2ExecutionTest {

	@Test
	def void test () {	
		new Mwe2Launcher().run(newArrayList ("src/org/eclipse/emf/xtendfactory/XtendFactoryTest.mwe2"));
		assertTrue (new File ("test-gen/org/eclipse/emf/xtendfactory/test/foo/util/FooFactoryXtend.xtend").exists())
	}
	
	@After
	def void cleanUp () {
		FileUtils::deleteRecursive (new File ("test-gen").listFiles);		
	}
		
}