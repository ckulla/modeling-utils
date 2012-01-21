package org.ckulla.xtend2utils.javacodegen

import org.eclipse.xtext.junit4.InjectWith
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import com.google.inject.Inject
import org.junit.Test
import org.junit.Before

import static org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(DefaultInjectorProvider))
class XtendImportManagerTest {
	
	@Inject XtendImportManager importManager

	@Before
	def void setUp () {
		importManager.setPackageName ("org.eclipse.foo")
		importManager.setClassName ("Foo")
	}	
	
	@Test
	def void testImportClassInOtherPackage () {
		assertEquals ("Bar", importManager.getImportedName("org.eclipse.bar.Bar"))
		assertEquals ("import org.eclipse.bar.Bar\n", importManager.importDeclarations.toString)
	}

	@Test
	def void testStaticImports () {
		assertEquals ("assertEquals", importManager.staticImportedName("org.junit.Assert.assertEquals"))
		assertEquals ('''
			import static org.junit.Assert.assertEquals
			'''.toString,
			importManager.importDeclarations.toString)
	}
	
	@Test
	def void testStaticDuplicates () {
		assertEquals ("assertEquals", importManager.staticImportedName("org.junit.Assert.assertEquals"))
		assertEquals ("org::junit::Bssert::assertEquals", importManager.staticImportedName("org.junit.Bssert.assertEquals"))
		assertEquals ('''
			import static org.junit.Assert.assertEquals
			'''.toString,
			importManager.importDeclarations.toString)
	}

}