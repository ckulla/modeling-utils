package org.ckulla.xtend2utils.cppcodegen.generator

import org.junit.contrib.rules.RulesTestRunner
import org.junit.contrib.rules.Rules
import org.junit.contrib.emf.EmfRegistryRule
import org.junit.contrib.guice.GuiceRule

import org.junit.Test
import org.junit.runner.RunWith
import com.google.inject.Inject
import static junit.framework.Assert.*

import org.ckulla.xtend2utils.cppcodegen.generator.Generator

import org.ckulla.xtend2utils.cppcodegen.builder.CppBuilder

import org.ckulla.xtend2utils.cppcodegen.cpp.EAccessControl
import org.ckulla.xtend2utils.cppcodegen.cpp.EPrimitiveType
import org.ckulla.xtend2utils.cppcodegen.cpp.util.CppFactoryXtend

@RunWith(typeof(RulesTestRunner))
@Rules({ typeof(EmfRegistryRule), typeof(GuiceRule) })
class ExampleClassTest {
	
	@Inject Generator generator

	@Inject extension CppBuilder

	@Inject CppFactoryXtend factory
	
	@Test
	def void test () {
		val baseClasses = newArrayList (factory.baseClass [ 
				type = includedType ("MyBaseClass1", "\"MyBaseClass1.h\"") 
				defaultInitializer = ""
			],
			factory.baseClass [ 
				type = includedType ("MyBaseClass2", "\"MyBaseClass2.h\"")
			]
		)
		
		val model = cppModel [
			it.clazz [
				name = "ExampleClass"
				it.baseClasses.addAll (baseClasses)
				headerText [
						$("// This is the header text section")							
				]			
				sourceText [
						$("// This is the source text section")						
				]				
				constructor [ 
					headerProlog [
						$("// This is the header prolog")
					]					
					sourceProlog [
						$("// This is the header prolog")
					]					
					comment = 
						"This is the default constructor. And it has a long and " +
						"stupid comment to demonstrate the line splitting for long " + 
						"comments."
					baseClassInitializer [
						baseClass = baseClasses.get(1)
						initializer = "\"Hello World\""
					]
					headerEpilog [
						$("// This is the header epilog")
					]					
				]
				destructor [ 
					isVirtual = true
				]
				field [
					name = "counter" 
					type = primitiveType (EPrimitiveType::INT)
					accessControl = EAccessControl::PRIVATE	
					defaultInitializer = "0"
				]
				method [
					name = "speak"
					returnType = includedType ("std::string", "<string>")
					parameter [
						name = "message1"
						type = const_ (reference (includedType ("std::string", "<string>")))
					]
					parameter [
						name = "message2"
						type = array (const_ (reference (includedType ("std::string", "<string>"))))
					]
					body [
						$('''counter++;''')
						$('''return message1;''') 
					]
				]
				method [
					comment = "Returns the number of calls to the speak method."
					name = "getCounter"
					isInline = true
					returnType = primitiveType(EPrimitiveType::INT)
					body [ $("return counter;")]
				]
			]
		]
		
		model.files.get(0).text [
			$("// Text section in header file")
		]
		model.files.get(1).text [
			$("// Text section in source file")
		]		
		assertEquals (expectedHeader(), generator.generate (model.files.get(0)).toString());
		assertEquals (expectedSource(), generator.generate (model.files.get(1)).toString());		
	}
	
	def expectedHeader() {
		'''
		#ifndef EXAMPLECLASS_HPP_
		#define EXAMPLECLASS_HPP_

		// Beginning of ExampleClass.hpp

		// This file is generated by the C++ Model code generator.

		// Do not change the contents of this file!
		// Any changes will be discarded on the next generator execution.

		#include "MyBaseClass1.h"
		#include "MyBaseClass2.h"
		#include <string>
		
		class ExampleClass : public MyBaseClass1, public MyBaseClass2 {
		
		public:
		
			// This is the header prolog
			/**
			 * This is the default constructor. And it has a long and stupid comment
			 * to demonstrate the line splitting for long comments.
			 */
			ExampleClass ();
			// This is the header epilog
		
			virtual ~ExampleClass ();
		
			/**
			 * Returns the number of calls to the speak method.
			 */
			int getCounter ()
			{
				return counter;
			}
		
			std::string speak (const std::string& message1, const std::string& message2[]);

			// This is the header text section

		private:

			int counter;
		
		};
		// Text section in header file
		
		// End of ExampleClass.hpp
		
		#endif // EXAMPLECLASS_HPP_
		'''.toString()	
	}
	
	def expectedSource() {
		'''
		// Beginning of ExampleClass.cpp

		// This file is generated by the C++ Model code generator.

		// Do not change the contents of this file!
		// Any changes will be discarded on the next generator execution.

		#include "ExampleClass.hpp"
		
		// This is the header prolog
		/**
		 * This is the default constructor. And it has a long and stupid comment
		 * to demonstrate the line splitting for long comments.
		 */
		// public
		ExampleClass::ExampleClass () :
			MyBaseClass1 (),
			MyBaseClass2 ("Hello World"),
			counter (0)
		{
		}
		
		// public virtual
		ExampleClass::~ExampleClass ()
		{
		}
		
		// public
		std::string ExampleClass::speak (const std::string& message1, const std::string& message2[])
		{
			counter++;
			return message1;
		}
		// Text section in source file
		
		// End of ExampleClass.cpp
		'''.toString()
	}
}