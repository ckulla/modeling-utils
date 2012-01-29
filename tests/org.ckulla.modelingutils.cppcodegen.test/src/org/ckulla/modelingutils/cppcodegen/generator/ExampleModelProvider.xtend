package org.ckulla.modelingutils.cppcodegen.generator

import com.google.inject.Inject

import org.ckulla.modelingutils.cppcodegen.builder.CppBuilder

import org.ckulla.modelingutils.cppcodegen.cpp.EAccessControl
import org.ckulla.modelingutils.cppcodegen.cpp.EPrimitiveType

class ExampleModelProvider {

	@Inject extension CppBuilder

	def get () {
		cppModel [
			it.clazz [
				name = "ExampleClass"
				constructor [ 
					comment = 
						"This is the default constructor. And it has a long and " +
						"stupid comment to demonstrate the line splitting for long " + 
						"comments."
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
			]
		]
	}

}