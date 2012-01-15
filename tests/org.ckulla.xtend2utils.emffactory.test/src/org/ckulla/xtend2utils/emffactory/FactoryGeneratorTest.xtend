package org.ckulla.xtend2utils.emffactory

import com.google.inject.Inject
import java.io.File
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import org.eclipse.emf.mwe.utils.StandaloneSetup

import static org.junit.Assert.*
import org.eclipse.emf.codegen.ecore.genmodel.GenModel
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(DefaultInjectorProvider))
class FactoryGeneratorTest {
	
	@Inject Generator factoryGenerator
	
	def doStandaloneSetup () {
		EcorePackage::eINSTANCE.getEFactoryInstance();
		GenModelPackage::eINSTANCE.getEFactoryInstance();
		
		val standaloneSetup = new StandaloneSetup ();
		standaloneSetup.setPlatformUri("..")	
	}
	
	def loadGenModel () {
		val genModel = "platform:/resource/org.ckulla.xtend2utils.emffactory.test/src/org/ckulla/xtend2utils/emffactory/XtendFactoryTest.genmodel"	
		val resSet = new ResourceSetImpl();
		resSet.getResource(URI::createURI(genModel), true).contents.get(0) as GenModel;
	}
	
	@Test
	def void testCompareContents () {		
		doStandaloneSetup
		val genModel = loadGenModel
		assertEquals ('''
			package org.ckulla.xtend2utils.emffactory.test.foo.util
			
			import org.ckulla.xtend2utils.emffactory.test.foo.Baz
			import org.ckulla.xtend2utils.emffactory.test.foo.FooFactory
			
			class FooFactoryXtend {
				
				def baz((Baz) => void initializer) {
					initialize (FooFactory::eINSTANCE.createBaz(), initializer)
				}
				
				def <T> T initialize (T t, (T) => void initializer) {
					initializer.apply (t)
					t
				}
			
			}
			'''.toString, 
			factoryGenerator.expand(genModel.genPackages.get(0), genModel).toString)
	}
	
	@Test
	def void testFileExists () {
		try {		
			doStandaloneSetup
			val genModel = loadGenModel
			factoryGenerator.generateFactory(genModel.genPackages.get(0), genModel)
			assertTrue (new File (factoryGenerator.targetFileName(genModel.genPackages.get(0), genModel)).exists());
		} finally {
			FileUtils::deleteRecursive(new File("test-gen"));
		}
	}	
}