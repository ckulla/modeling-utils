package org.ckulla.modelingutils.cppcodegen.generator

import com.google.inject.Inject
import org.ckulla.modelingutils.cppcodegen.builder.CppBuilder
import org.junit.Test
import org.junit.contrib.emf.EmfRegistryRule
import org.junit.contrib.guice.GuiceRule
import org.junit.contrib.rules.Rules
import org.junit.contrib.rules.RulesTestRunner
import org.junit.runner.RunWith

import static junit.framework.Assert.*

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