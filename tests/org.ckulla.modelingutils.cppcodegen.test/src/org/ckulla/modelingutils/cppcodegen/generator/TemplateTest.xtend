package org.ckulla.modelingutils.cppcodegen.generator

import org.junit.Test
import org.junit.runner.RunWith
import com.google.inject.Inject
import static junit.framework.Assert.*

import org.ckulla.modelingutils.cppcodegen.generator.Generator

import org.ckulla.modelingutils.cppcodegen.builder.CppBuilder

import org.ckulla.modelingutils.cppcodegen.cpp.EAccessControl
import org.ckulla.modelingutils.cppcodegen.cpp.EPrimitiveType
import org.ckulla.modelingutils.cppcodegen.cpp.util.CppFactoryXtend
import org.ckulla.modelingutils.testutils.rules.RulesTestRunner
import org.ckulla.modelingutils.testutils.emf.EmfRegistryRule
import org.ckulla.modelingutils.testutils.guice.GuiceRule
import org.ckulla.modelingutils.testutils.rules.Rules

@RunWith(typeof(RulesTestRunner))
@Rules({ typeof(EmfRegistryRule), typeof(GuiceRule) })
class TemplateTest {

	@Inject Generator generator

	@Inject extension CppBuilder

	@Inject CppFactoryXtend factory
	
	@Test
	def void test () {
		val model = cppModel [
			templateClazz [
				name = "MySequence"
				arguments.add (factory.templateArgument [ prefix = "class" name = "T" ]);
				arguments.add (factory.templateArgument [ prefix = "int" name = "N" ]);

				constructor [ 
				]
				destructor [ 
					isVirtual = true
				]
				field [
					name = "memblock" 
					type = array (factory.namedType [ name = "T" ], "N")
					accessControl = EAccessControl::PRIVATE	
					defaultInitializer = "0"
				]
				method [
					name = "setMember"
					parameter [
						name = "x"
						type = primitiveType (EPrimitiveType::INT)
					]
					parameter [
						name = "value"
						type = factory.namedType [name = "T"]
					]
					body [						
						$("memblock[x]=value;")
					]
				]
				method [
					name = "getMember"
					returnType = factory.namedType [name = "T"]
					parameter [
						name = "x"
						type = primitiveType (EPrimitiveType::INT)
					]
					body [
						$("return memblock[x];")
					]
				]
			]
		]
		
		assertEquals (expectedHeader(), generator.generate (model.files.get(0)).toString());
		assertEquals (expectedSource(), generator.generate (model.files.get(1)).toString());		
	}
	
	def expectedHeader() {
		'''
		#ifndef MYSEQUENCE_HPP_
		#define MYSEQUENCE_HPP_
		
		// Beginning of MySequence.hpp
		
		// This file is generated by the C++ Model code generator.
		
		// Do not change the contents of this file!
		// Any changes will be discarded on the next generator execution.
		
		
		template <class T, int N>
		class MySequence {
		
		public:

			MySequence ();
			{
			}

			virtual ~MySequence ();
			{
			}

			T getMember (int x);
			{
				return memblock[x];
			}

			void setMember (int x, T value);
			{
				memblock[x]=value;
			}
		
		private:
		
			T memblock[N];
		
		};
		
		// End of MySequence.hpp
		
		#endif // MYSEQUENCE_HPP_
		'''.toString()	
	}
	
	def expectedSource() {
		'''
		// Beginning of MySequence.cpp

		// This file is generated by the C++ Model code generator.

		// Do not change the contents of this file!
		// Any changes will be discarded on the next generator execution.


		// End of MySequence.cpp
		'''.toString()
	}
	
}