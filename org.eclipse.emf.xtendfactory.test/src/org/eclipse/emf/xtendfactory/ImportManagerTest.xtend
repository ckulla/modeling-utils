package org.eclipse.emf.xtendfactory

import org.eclipse.xtext.junit4.InjectWith
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import com.google.inject.Inject
import org.junit.Test
import org.junit.Before

import static org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(DefaultInjectorProvider))
class ImportManagerTest {
	
	@Inject ImportManager importManager

	@Before
	def void setUp () {
		importManager.setPackageName ("org.eclipse.foo")
		importManager.setClassName ("Foo")
	}	
	
	@Test
	def void testImportIteself () {
		assertEquals ("Foo", importManager.getImportedName("org.eclipse.foo.Foo"))
		assertEquals ("", importManager.importDeclarations.toString)
	}

	@Test
	def void testImportClassInSamePackage () {
		assertEquals ("Bar", importManager.getImportedName("org.eclipse.foo.Bar"))
		assertEquals ("Bar", importManager.getImportedName("org.eclipse.foo.Bar"))
		assertEquals ("", importManager.importDeclarations.toString)
	}

	@Test
	def void testImportClassInOtherPackage () {
		assertEquals ("Bar", importManager.getImportedName("org.eclipse.bar.Bar"))
		assertEquals ("import org.eclipse.bar.Bar;\n", importManager.importDeclarations.toString)
	}

	@Test
	def void testImportSameClassInDifferentPackages () {
		assertEquals ("Bar", importManager.getImportedName("org.eclipse.foo.Bar"))		
		assertEquals ("org.eclipse.bar.Bar", importManager.getImportedName("org.eclipse.bar.Bar"))
		assertEquals ("Bar", importManager.getImportedName("org.eclipse.foo.Bar"))		
		assertEquals ("", importManager.importDeclarations.toString)
	}

	@Test
	def void testImportSameClassInDifferentPackages2 () {
		assertEquals ("Bar", importManager.getImportedName("org.eclipse.bar.Bar"))
		assertEquals ("org.eclipse.foo.Bar", importManager.getImportedName("org.eclipse.foo.Bar"))		
		assertEquals ("Bar", importManager.getImportedName("org.eclipse.bar.Bar"))
		assertEquals ("import org.eclipse.bar.Bar;\n", importManager.importDeclarations.toString)
	}

	@Test
	def void testImportFromMultiplePackages () {
		assertEquals ("Bar", importManager.getImportedName("org.eclipse.bar.Bar"))
		assertEquals ("Baz", importManager.getImportedName("org.eclipse.baz.Baz"))

		assertEquals ('''
			import org.eclipse.bar.Bar;
			
			import org.eclipse.baz.Baz;
		'''.toString, importManager.importDeclarations.toString)
	}

}