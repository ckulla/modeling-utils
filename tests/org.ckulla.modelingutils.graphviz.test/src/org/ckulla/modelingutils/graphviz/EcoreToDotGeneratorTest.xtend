package org.ckulla.modelingutils.graphviz

import org.junit.Test
import org.eclipse.emf.mwe2.launch.runtime.Mwe2Launcher
import java.io.File
import org.junit.After

import static org.junit.Assert.*
import org.junit.runner.RunWith
import org.junit.contrib.rules.Rules
import org.junit.contrib.rules.RulesTestRunner
import org.junit.contrib.guice.GuiceRule

@RunWith(typeof (RulesTestRunner))
@Rules({ typeof (GuiceRule) })
class EcoreToDotGeneratorTest {

	@Test
	def void test () {	
		new Mwe2Launcher().run(newArrayList ("src/org/ckulla/modelingutils/graphviz/EcoreToDotGeneratorTest.mwe2"));
		assertTrue (new File ("test-gen/foo/EcoreToDotGeneratorTest.png").exists())
	}
	
	@After
	def void cleanUp () {
		FileUtils::deleteRecursive (new File ("test-gen"));		
	}
		
}