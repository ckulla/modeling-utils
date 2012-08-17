package org.ckulla.modelingutils.cppcodegen.generator

import org.junit.Test
import org.junit.runner.RunWith
import com.google.inject.Inject
import static junit.framework.Assert.*

import org.ckulla.modelingutils.cppcodegen.generator.BaseGenerator

import org.ckulla.modelingutils.cppcodegen.builder.CppBuilder
import org.ckulla.modelingutils.cppcodegen.cpp.EPrimitiveType
import org.ckulla.modelingutils.testutils.rules.Rules
import org.ckulla.modelingutils.testutils.guice.GuiceRule
import org.ckulla.modelingutils.testutils.rules.RulesTestRunner
import org.ckulla.modelingutils.testutils.emf.EmfRegistryRule

@RunWith(typeof(RulesTestRunner))
@Rules({ typeof(EmfRegistryRule), typeof(GuiceRule) })
class BaseGeneratorTest {

	@Inject extension CppBuilder

	@Inject extension BaseGenerator baseGenerator
	
	@Test
	def void testExpandType_Include () {
		assertEquals ("foo", expandType(includedType ("foo", "foo.h")).toString);
		assertEquals (1, baseGenerator.includeManager.includes.size());
	}
	
	@Test
	def void testExpandType_Pointer () {
		assertEquals ("foo*", expandType(pointer (includedType ("foo", "foo.h"))).toString);
		assertEquals (1, baseGenerator.includeManager.includes.size());
	}

	@Test
	def void testExpandType_Reference () {
		assertEquals ("foo&", expandType(reference (includedType ("foo", "foo.h"))).toString);
		assertEquals (1, baseGenerator.includeManager.includes.size());
	}

	@Test
	def void testExpandType_Const () {
		assertEquals ("const foo", expandType(const_ (includedType ("foo", "foo.h"))).toString);
		assertEquals (1, baseGenerator.includeManager.includes.size());
	}
	
	@Test
	def void testExpandType_Array () {
		assertEquals ("const foo", expandType(array(const_ (includedType ("foo", "foo.h")))).toString);
		assertEquals ("foo", expandType(array(includedType ("foo", "foo.h"), "2")).toString);
		assertEquals (1, baseGenerator.includeManager.includes.size());
	}

	@Test
	def void testExpandTypePostfix_Array () {
		assertEquals ("[]", expandTypePostfix(array(const_ (includedType ("foo", "foo.h")))).toString);
		assertEquals ("[2][]", expandTypePostfix(array(array(includedType ("foo", "foo.h"), "2"))).toString);
	}
	
	@Test
	def void testExpandType_PrimitiveType () {
		assertEquals ("int", expandType(primitiveType(EPrimitiveType::INT)).toString);
		assertEquals (0, baseGenerator.includeManager.includes.size());
	}
	
	@Test
	def void testExpandType_Template () {
		assertEquals ("Pair<int, foo&>", 
			expandType(template [
				type = includedType ("Pair", "Pair.h")
				argument [
					primitiveType(EPrimitiveType::INT)
				]
				argument [
					reference (includedType ("foo", "foo.h"))
				]
			]).toString);
		assertEquals (2, baseGenerator.includeManager.includes.size());
	}
	
	@Test
	def void testExpandType_Class () {		
		assertEquals ("foo",
			expandType(cppModel [
				clazz [
					name = "foo"
				]
			].classes.get(0)).toString);
		assertEquals (1, baseGenerator.includeManager.includes.size());
	}
	
	@Test
	def void testExpandType_NestedClass () {
		val model = cppModel [
			clazz [
				name = "foo"
			]
		]
		val cut = model.classes.get(0).clazz [
			name = "bar"
		]
				
		assertEquals ("foo::bar", expandType(cut).toString);
		assertEquals (1, baseGenerator.includeManager.includes.size());
	}
	
	@Test
	def void testExpandType_NestedEnumeration () {
		val model = cppModel [
				clazz [
					name = "foo"
				]
			]
		val enumeration = model.classes.get(0).enumeration [
			name = "bar"
		]
		
		assertEquals ("foo::bar", expandType(enumeration).toString);
		assertEquals (1, baseGenerator.includeManager.includes.size());
	}

	@Test
	def void testExpandType_Namespace () {
		val model = cppModel [
				clazz [
					name = "bar"
					namespace = namespace (namespace ("foo"), "std")
				]
			]
		
		assertEquals ("foo::std::bar", expandType(model.classes.get(0)).toString);
		assertEquals (1, baseGenerator.includeManager.includes.size());
	}

	// FIXME: expand parameter
	// FIXME: expand strings
	// FIXME: FQN
	// FIXME: name
	// FIXME: expand for IncludeManager
}