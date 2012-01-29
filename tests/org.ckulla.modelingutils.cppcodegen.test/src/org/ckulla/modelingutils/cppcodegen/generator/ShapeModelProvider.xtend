package org.ckulla.modelingutils.cppcodegen.generator

import com.google.inject.Inject

import org.ckulla.modelingutils.cppcodegen.builder.CppBuilder

class ShapeModelProvider {

	@Inject extension CppBuilder

	def get () {
		cppModel [
			val shape = it.clazz [
				name = "Shape"
				destructor [ 
					isVirtual = true
					isAbstract = true
				]
				method [
					name = "draw" 
					isVirtual = true
					isAbstract = true
				]
			]
			it.clazz [
				name = "Circle"
				baseClass [
					type = shape
				]
				destructor [ 
					isVirtual = true
					isAbstract = true
				]
				method [
					name = "draw" 
					isVirtual = true
					body [
						$('''cout << "This is a circle" << endl;''')
					]
				]
			]
			it.clazz [
				name = "Rectangle"
				baseClass [
					type = shape
				]
				destructor [ 
					isVirtual = true
					isAbstract = true
				]
				method [
					name = "draw" 
					isVirtual = true
					body [
						$('''cout << "This is a rectangle" << endl;''')
					]
				]
			]
			it.clazz [
				name = "CompositeShape"
				baseClass [
					type = shape
				]
				destructor [ 
					isVirtual = true
					isAbstract = true
				]
				field [
					name = "shapes"
					type = template [
						type = includedType ("std::vector", "<vector>")
						argument [ shape ]
					]
				]
				method [
					name = "addShape" 
					isVirtual = true
					parameter [
						name = "shape"
						type = reference (shape)
					]
					body [
						$('''shapes.push_back (shape)''')
					]
				]				
				method [
					name = "draw" 
					isVirtual = true
					body [
						$('''cout << "This is a composite" << endl;''')
						$('''for (int i = 0 : i<shapes.size(); i++) {''')
						$('''	shapes[i].draw()''')
						$('''}''')
					]
				]
			]			
		]
	}	
}