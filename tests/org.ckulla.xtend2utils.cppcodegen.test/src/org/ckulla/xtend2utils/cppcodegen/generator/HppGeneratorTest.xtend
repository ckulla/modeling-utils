package org.ckulla.xtend2utils.cppcodegen.generator

import org.junit.contrib.rules.RulesTestRunner
import org.junit.contrib.rules.Rules
import org.junit.contrib.emf.EmfRegistryRule
import org.junit.contrib.guice.GuiceRule

import org.junit.Test
import org.junit.runner.RunWith
import com.google.inject.Inject
import static junit.framework.Assert.*

import org.ckulla.xtend2utils.cppcodegen.builder.CppBuilder

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