package org.ckulla.xtend2utils.graphviz

import org.junit.Test
import org.eclipse.emf.mwe2.launch.runtime.Mwe2Launcher
import java.io.File
import org.junit.After

import static org.junit.Assert.*
import org.junit.runner.RunWith
import org.junit.contrib.rules.Rules
import org.junit.contrib.rules.RulesTestRunner
import org.junit.contrib.emf.EmfRegistryRule
import org.junit.contrib.guice.GuiceRule

@RunWith(typeof (RulesTestRunner))
@Rules({ typeof(EmfRegistryRule), typeof (GuiceRule) })
class EcoreToDotGeneratorTest {

	@Test
	def void test () {	
		new Mwe2Launcher().run(newArrayList ("src/org/ckulla/xtend2utils/graphviz/EcoreToDotGeneratorTest.mwe2"));
		assertTrue (new File ("test-gen/foo.png").exists())
	}
	
	@After
	def void cleanUp () {
		FileUtils::deleteRecursive (new File ("test-gen"));		
	}
		
}