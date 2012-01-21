package org.eclipse.cppgenmodel.cpp.util

import org.eclipse.cppgenmodel.cpp.ArrayType
import org.eclipse.cppgenmodel.cpp.BaseClass
import org.eclipse.cppgenmodel.cpp.BaseClassInitializer
import org.eclipse.cppgenmodel.cpp.ClassElement
import org.eclipse.cppgenmodel.cpp.Clazz
import org.eclipse.cppgenmodel.cpp.ConstType
import org.eclipse.cppgenmodel.cpp.Constructor
import org.eclipse.cppgenmodel.cpp.CppFactory
import org.eclipse.cppgenmodel.cpp.CppModel
import org.eclipse.cppgenmodel.cpp.Destructor
import org.eclipse.cppgenmodel.cpp.Enumeration
import org.eclipse.cppgenmodel.cpp.Field
import org.eclipse.cppgenmodel.cpp.FieldInitializer
import org.eclipse.cppgenmodel.cpp.File
import org.eclipse.cppgenmodel.cpp.HeaderFile
import org.eclipse.cppgenmodel.cpp.HeaderTextSection
import org.eclipse.cppgenmodel.cpp.IncludedType
import org.eclipse.cppgenmodel.cpp.Literal
import org.eclipse.cppgenmodel.cpp.Method
import org.eclipse.cppgenmodel.cpp.NVPair
import org.eclipse.cppgenmodel.cpp.NamedType
import org.eclipse.cppgenmodel.cpp.Namespace
import org.eclipse.cppgenmodel.cpp.Parameter
import org.eclipse.cppgenmodel.cpp.PointerType
import org.eclipse.cppgenmodel.cpp.PrimitiveType
import org.eclipse.cppgenmodel.cpp.ReferenceType
import org.eclipse.cppgenmodel.cpp.SourceFile
import org.eclipse.cppgenmodel.cpp.SourceTextSection
import org.eclipse.cppgenmodel.cpp.Struct
import org.eclipse.cppgenmodel.cpp.TemplateArgument
import org.eclipse.cppgenmodel.cpp.TemplateClazz
import org.eclipse.cppgenmodel.cpp.TemplateType
import org.eclipse.cppgenmodel.cpp.TextSection

class CppFactoryXtend {
	
	def cppModel((CppModel) => void initializer) {
		initialize (CppFactory::eINSTANCE.createCppModel(), initializer)
	}
	
	def textSection((TextSection) => void initializer) {
		initialize (CppFactory::eINSTANCE.createTextSection(), initializer)
	}
	
	def file((File) => void initializer) {
		initialize (CppFactory::eINSTANCE.createFile(), initializer)
	}
	
	def headerFile((HeaderFile) => void initializer) {
		initialize (CppFactory::eINSTANCE.createHeaderFile(), initializer)
	}
	
	def sourceFile((SourceFile) => void initializer) {
		initialize (CppFactory::eINSTANCE.createSourceFile(), initializer)
	}
	
	def includedType((IncludedType) => void initializer) {
		initialize (CppFactory::eINSTANCE.createIncludedType(), initializer)
	}
	
	def templateType((TemplateType) => void initializer) {
		initialize (CppFactory::eINSTANCE.createTemplateType(), initializer)
	}
	
	def enumeration((Enumeration) => void initializer) {
		initialize (CppFactory::eINSTANCE.createEnumeration(), initializer)
	}
	
	def clazz((Clazz) => void initializer) {
		initialize (CppFactory::eINSTANCE.createClazz(), initializer)
	}
	
	def baseClass((BaseClass) => void initializer) {
		initialize (CppFactory::eINSTANCE.createBaseClass(), initializer)
	}
	
	def classElement((ClassElement) => void initializer) {
		initialize (CppFactory::eINSTANCE.createClassElement(), initializer)
	}
	
	def field((Field) => void initializer) {
		initialize (CppFactory::eINSTANCE.createField(), initializer)
	}
	
	def constructor((Constructor) => void initializer) {
		initialize (CppFactory::eINSTANCE.createConstructor(), initializer)
	}
	
	def destructor((Destructor) => void initializer) {
		initialize (CppFactory::eINSTANCE.createDestructor(), initializer)
	}
	
	def method((Method) => void initializer) {
		initialize (CppFactory::eINSTANCE.createMethod(), initializer)
	}
	
	def parameter((Parameter) => void initializer) {
		initialize (CppFactory::eINSTANCE.createParameter(), initializer)
	}
	
	def struct((Struct) => void initializer) {
		initialize (CppFactory::eINSTANCE.createStruct(), initializer)
	}
	
	def literal((Literal) => void initializer) {
		initialize (CppFactory::eINSTANCE.createLiteral(), initializer)
	}
	
	def nVPair((NVPair) => void initializer) {
		initialize (CppFactory::eINSTANCE.createNVPair(), initializer)
	}
	
	def primitiveType((PrimitiveType) => void initializer) {
		initialize (CppFactory::eINSTANCE.createPrimitiveType(), initializer)
	}
	
	def namedType((NamedType) => void initializer) {
		initialize (CppFactory::eINSTANCE.createNamedType(), initializer)
	}
	
	def referenceType((ReferenceType) => void initializer) {
		initialize (CppFactory::eINSTANCE.createReferenceType(), initializer)
	}
	
	def pointerType((PointerType) => void initializer) {
		initialize (CppFactory::eINSTANCE.createPointerType(), initializer)
	}
	
	def constType((ConstType) => void initializer) {
		initialize (CppFactory::eINSTANCE.createConstType(), initializer)
	}
	
	def namespace((Namespace) => void initializer) {
		initialize (CppFactory::eINSTANCE.createNamespace(), initializer)
	}
	
	def baseClassInitializer((BaseClassInitializer) => void initializer) {
		initialize (CppFactory::eINSTANCE.createBaseClassInitializer(), initializer)
	}
	
	def fieldInitializer((FieldInitializer) => void initializer) {
		initialize (CppFactory::eINSTANCE.createFieldInitializer(), initializer)
	}
	
	def arrayType((ArrayType) => void initializer) {
		initialize (CppFactory::eINSTANCE.createArrayType(), initializer)
	}
	
	def templateClazz((TemplateClazz) => void initializer) {
		initialize (CppFactory::eINSTANCE.createTemplateClazz(), initializer)
	}
	
	def templateArgument((TemplateArgument) => void initializer) {
		initialize (CppFactory::eINSTANCE.createTemplateArgument(), initializer)
	}
	
	def sourceTextSection((SourceTextSection) => void initializer) {
		initialize (CppFactory::eINSTANCE.createSourceTextSection(), initializer)
	}
	
	def headerTextSection((HeaderTextSection) => void initializer) {
		initialize (CppFactory::eINSTANCE.createHeaderTextSection(), initializer)
	}
	
	def <T> T initialize (T t, (T) => void initializer) {
		initializer.apply (t)
		t
	}

}
