package org.ckulla.xtend2utils.cppcodegen.generator

import org.junit.Test
import org.junit.contrib.emf.EmfRegistryRule
import org.junit.contrib.guice.GuiceRule
import org.junit.contrib.rules.Rules
import org.junit.contrib.rules.RulesTestRunner
import org.junit.runner.RunWith

@RunWith(typeof(RulesTestRunner))
@Rules({ typeof(EmfRegistryRule), typeof(GuiceRule) })
class IncludeManagerTest {

	@Test
	def void test () {
	}

}