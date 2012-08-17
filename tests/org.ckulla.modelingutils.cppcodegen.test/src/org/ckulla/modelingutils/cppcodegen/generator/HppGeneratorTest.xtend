package org.ckulla.modelingutils.cppcodegen.generator

import org.junit.Test
import org.junit.runner.RunWith
import com.google.inject.Inject
import static junit.framework.Assert.*

import org.ckulla.modelingutils.cppcodegen.builder.CppBuilder
import org.ckulla.modelingutils.testutils.rules.RulesTestRunner
import org.ckulla.modelingutils.testutils.emf.EmfRegistryRule
import org.ckulla.modelingutils.testutils.guice.GuiceRule
import org.ckulla.modelingutils.testutils.rules.Rules

@RunWith(typeof(RulesTestRunner))
@Rules({ typeof(EmfRegistryRule), typeof(GuiceRule) })
class HppGeneratorTest {

	@Inject extension CppBuilder

	@Inject extension HppGenerator hppGenerator
	
	@Test
	def void test_Namespace () {
		val model = cppModel [
				clazz [
					name = "foo"
					namespace = namespace (namespace ("bar"), "baz")
				]
			]
		
		assertEquals ('''
			
			namespace bar {
				
				namespace baz {
					
					class foo {
					
					};
				}
			}
			'''.toString, expand(model.classes.get(0)).toString);
		assertEquals (0, hppGenerator.includeManager.includes.size());
	}

}