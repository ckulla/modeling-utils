package org.ckulla.xtend2utils.cppcodegen.builder

import com.google.inject.Inject
import java.util.List
import org.ckulla.xtend2utils.cppcodegen.cpp.AbstractType
import org.ckulla.xtend2utils.cppcodegen.cpp.BaseClass
import org.ckulla.xtend2utils.cppcodegen.cpp.BaseClassInitializer
import org.ckulla.xtend2utils.cppcodegen.cpp.ClassElement
import org.ckulla.xtend2utils.cppcodegen.cpp.Clazz
import org.ckulla.xtend2utils.cppcodegen.cpp.Constructor
import org.ckulla.xtend2utils.cppcodegen.cpp.CppFactory
import org.ckulla.xtend2utils.cppcodegen.cpp.CppModel
import org.ckulla.xtend2utils.cppcodegen.cpp.Destructor
import org.ckulla.xtend2utils.cppcodegen.cpp.EPrimitiveType
import org.ckulla.xtend2utils.cppcodegen.cpp.Enumeration
import org.ckulla.xtend2utils.cppcodegen.cpp.Field
import org.ckulla.xtend2utils.cppcodegen.cpp.FieldInitializer
import org.ckulla.xtend2utils.cppcodegen.cpp.File
import org.ckulla.xtend2utils.cppcodegen.cpp.Method
import org.ckulla.xtend2utils.cppcodegen.cpp.Namespace
import org.ckulla.xtend2utils.cppcodegen.cpp.Operation
import org.ckulla.xtend2utils.cppcodegen.cpp.Parameter
import org.ckulla.xtend2utils.cppcodegen.cpp.TemplateClazz
import org.ckulla.xtend2utils.cppcodegen.cpp.TemplateType
import org.ckulla.xtend2utils.cppcodegen.cpp.util.CppFactoryXtend

class CppBuilder {
	
	@Inject extension CppFactoryXtend
	
	def cppModel ( (CppModel) => void initializer) {
		CppFactory::eINSTANCE.createCppModel().init (initializer);
	}
	
	def templateClazz (CppModel it, (TemplateClazz) => void initializer) {
		// create the class
		val clazz = CppFactory::eINSTANCE.createTemplateClazz().init (initializer);
		
		setupClass (clazz)
	}

	def clazz (CppModel it, (Clazz) => void initializer) {
		// create the class
		val clazz = CppFactory::eINSTANCE.createClazz().init (initializer);
		
		setupClass (clazz)
	}

	def private setupClass (CppModel it, Clazz clazz) {
		// add the clazz to the model
		classes.add (clazz);
		
		// create the header file
		files.add(headerFile [
			it.name = clazz.name + ".hpp"
			sections.add (clazz)
			clazz.headerFile = it
		])
		
		// create and add the source file
		files.add (sourceFile [
			it.name = clazz.name + ".cpp"
			sections.add (clazz)
			headerFile = clazz.headerFile
			clazz.sourceFile = it
		])
		
		// return clazz
		clazz		
	}
	
	def clazz (Clazz it, (Clazz) => void initializer) {
		// create the class
		val clazz = CppFactory::eINSTANCE.createClazz().init (initializer);
		elements.add (clazz)
		clazz
	}

	def baseClass (Clazz it, (BaseClass) => void initializer) {
		// create the class
		val baseClazz = CppFactory::eINSTANCE.createBaseClass().init (initializer);
		baseClasses.add (baseClazz)
		clazz
	}

	def constructor ( Clazz it, (Constructor) => void initializer) {
		val x =	CppFactory::eINSTANCE.createConstructor().init (initializer);
		elements.add (x);
		x
	}
	
	def destructor ( Clazz it, (Destructor) => void initializer) {
		val x =	CppFactory::eINSTANCE.createDestructor().init (initializer);
		elements.add (x);
		x
	}
	
	def method ( Clazz it, (Method) => void initializer) {
		val x =	CppFactory::eINSTANCE.createMethod().init (initializer);
		elements.add (x);
		x
	}
	
	def field ( Clazz it, (Field) => void initializer) {
		val x = CppFactory::eINSTANCE.createField().init (initializer)
		elements.add (x);
		x
	}
	
	def primitiveType (EPrimitiveType pt) {
	 	primitiveType [ primitiveType = pt]	
	}

	def includedType (String name, String includeFile) {
		includedType [
			it.name = name;
			it.includeFile = includeFile;
		]
	}

	def const_ (AbstractType type) {
		constType [
			it.type = type
		]
	}
	
	def array (AbstractType type) {
		arrayType [
			it.type = type
		]
	}
	
	def array (AbstractType type, String size) {
		arrayType [
			it.type = type
			it.size = size
		]
	}

	def reference (AbstractType type) {
		referenceType [
			it.type = type
		]			
	}

	def pointer (AbstractType type) {
		pointerType [
			it.type = type
		]			
	}
	
	def template ((TemplateType) => void initializer) {
		val x =	CppFactory::eINSTANCE.createTemplateType().init (initializer);
		x
	}

	def argument (TemplateType it, (Object) => AbstractType typeExpression) {
		arguments.add (typeExpression.apply(null));
	}
	
	def parameter (Method it, (Parameter) => void initializer) {
		val x =	CppFactory::eINSTANCE.createParameter().init (initializer);
		it.parameters.add(x)
		x
	}

	def constructorParameter (Constructor it, (Parameter) => void initializer) {
		val x =	CppFactory::eINSTANCE.createParameter().init (initializer);
		it.parameters.add(x)
		x
	}
	
	def enumeration (Clazz it, (Enumeration) => void initializer) {
		val x = enumeration (initializer)
		elements.add (x);
		x
	} 

	def baseClassInitializer ( Constructor it, (BaseClassInitializer) => void initializer) {
		val x = CppFactory::eINSTANCE.createBaseClassInitializer().init (initializer);
		initializers.add (x)
		x
	}
	
	def fieldInitializer ( Constructor it, (FieldInitializer) => void initializer) {
		val x = CppFactory::eINSTANCE.createFieldInitializer().init (initializer);
		initializers.add (x)
		x
	}
	
	def List<String> body ( Operation it, (List<String>) => void initializer) {
		initializer.apply(body)
		body
	}

	def text ( File it, (List<String>) => void initializer) {
		val section = CppFactory::eINSTANCE.createTextSection ()
		initializer.apply(section.text)
		it.sections.add(section)
		section
	}

	def headerProlog ( ClassElement it, (List<String>) => void initializer) {
		initializer.apply(headerProlog)
	}

	def headerEpilog ( ClassElement it, (List<String>) => void initializer) {
		initializer.apply(headerEpilog)
	}

	def sourceProlog ( ClassElement it, (List<String>) => void initializer) {
		initializer.apply(sourceProlog)
	}
	
	def sourceEpilog ( ClassElement it, (List<String>) => void initializer) {
		initializer.apply(sourceEpilog)
	}

	def sourceText (Clazz it, (List<String>) => void initializer) {
		val section = CppFactory::eINSTANCE.createSourceTextSection ()
		initializer.apply(section.text)
		elements.add (section)
		section
	}

	def headerText (Clazz it, (List<String>) => void initializer) {
		val section = CppFactory::eINSTANCE.createHeaderTextSection ()
		initializer.apply(section.text)
		elements.add (section)
		section
	}
	
	def namespace (Namespace parent, String name) {
		namespace [ it.name = name  it.parent = parent ]
	}

	def namespace (String name) {
		namespace [ it.name = name ]
	}
	
	def $(List<String> list, String s) {
		list.add (s);
	}				

	def $(List<String> list, CharSequence sc) {
		list.add (sc.toString);
	}	
	
	def private <T> init (T obj, (T)=>void initializer) {
		initializer.apply (obj);
		obj;
	}
}