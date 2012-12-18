package org.ckulla.modelingutils.emffactory

import org.junit.Test
import org.eclipse.emf.mwe2.launch.runtime.Mwe2Launcher
import java.io.File
import org.junit.After

import static org.junit.Assert.*

class XtendEmfFactoryGeneratorTest {

	@Test
	def void test () {	
		new Mwe2Launcher().run(newArrayList ("src/org/ckulla/modelingutils/emffactory/XtendEmfFactoryGeneratorTest.mwe2"));
		assertTrue (new File ("test-gen/org/ckulla/modelingutils/emffactory/test/foo/util/FooFactoryXtend.xtend").exists())
		assertTrue (new File ("test-gen/org/ckulla/modelingutils/emffactory/test/foo/baz/util/BazFactoryXtend.xtend").exists())
	}
	
	@After
	def void cleanUp () {
		FileUtils::deleteRecursive (new File ("test-gen"));		
	}
		
}