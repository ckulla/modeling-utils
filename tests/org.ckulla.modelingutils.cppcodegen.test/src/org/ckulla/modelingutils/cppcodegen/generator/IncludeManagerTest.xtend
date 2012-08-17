package org.ckulla.modelingutils.cppcodegen.generator

import org.junit.Test
import org.junit.runner.RunWith
import org.ckulla.modelingutils.testutils.rules.RulesTestRunner
import org.ckulla.modelingutils.testutils.emf.EmfRegistryRule
import org.ckulla.modelingutils.testutils.guice.GuiceRule
import org.ckulla.modelingutils.testutils.rules.Rules

@RunWith(typeof(RulesTestRunner))
@Rules({ typeof(EmfRegistryRule), typeof(GuiceRule) })
class IncludeManagerTest {

	@Test
	def void test () {
	}

}