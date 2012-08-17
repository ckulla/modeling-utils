package org.ckulla.modelingutils.cppcodegen.generator

import com.google.inject.Inject
import org.ckulla.modelingutils.cppcodegen.builder.CppBuilder
import org.junit.Test
import org.junit.runner.RunWith

import static junit.framework.Assert.*
import org.ckulla.modelingutils.testutils.rules.RulesTestRunner
import org.ckulla.modelingutils.testutils.rules.Rules
import org.ckulla.modelingutils.testutils.emf.EmfRegistryRule
import org.ckulla.modelingutils.testutils.guice.GuiceRule

@RunWith(typeof(RulesTestRunner))
@Rules({ typeof(EmfRegistryRule), typeof(GuiceRule) })
class CppGeneratorTest {

	@Inject extension CppBuilder

	@Inject extension CppGenerator cppGenerator
	
	@Test
	def void test_Namespace () {
		val model = cppModel [
				it.clazz [
					name = "Foo"
					namespace = namespace (namespace ("bar"), "baz")
					constructor [
					]
				]
			]
		
		assertEquals ('''
			
			// public
			bar::baz::Foo::Foo ()
			{
			}
			'''.toString, expand(model.classes.get(0)).toString);
	}
}