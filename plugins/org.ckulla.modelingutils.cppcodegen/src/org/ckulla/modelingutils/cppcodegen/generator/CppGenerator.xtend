package org.ckulla.modelingutils.cppcodegen.generator

import com.google.inject.Inject
import com.google.inject.Provider

import java.util.List
import java.util.Collection

import org.ckulla.modelingutils.cppcodegen.cpp.FileSection
import org.ckulla.modelingutils.cppcodegen.cpp.ClassElement
import org.ckulla.modelingutils.cppcodegen.cpp.Clazz
import org.ckulla.modelingutils.cppcodegen.cpp.Constructor
import org.ckulla.modelingutils.cppcodegen.cpp.Destructor
import org.ckulla.modelingutils.cppcodegen.cpp.Method
import org.ckulla.modelingutils.cppcodegen.cpp.SourceFile
import org.ckulla.modelingutils.cppcodegen.cpp.Field
import org.ckulla.modelingutils.cppcodegen.cpp.BaseClass
import org.ckulla.modelingutils.cppcodegen.cpp.TemplateClazz
import org.ckulla.modelingutils.cppcodegen.cpp.BaseClassInitializer
import org.ckulla.modelingutils.cppcodegen.cpp.FieldInitializer
import org.ckulla.modelingutils.cppcodegen.cpp.TextSection

class CppGenerator {
		
	@Inject Provider<HppGenerator> hppGeneratorProvider

	@Inject extension BaseGenerator
	
	/**
	 * Returns the textual representation of the source file.
	 */
	def expand (SourceFile sf) {
		val body = sf.body
		
		if (sf.headerFile != null) {
			// generate the header file and remove all includes which are already included there
			val hppGenerator = hppGeneratorProvider.get
			hppGenerator.expand (sf.headerFile)
			includeManager.removeIncludes (hppGenerator.includeManager)
		}
				
		'''
		«sf.fileHeader»
		«includeManager.expand»
		«body»
		«sf.fileFooter»
		'''	
	}
	
	def body(SourceFile sf) '''«FOR s:sf.sections»«s.expand»«ENDFOR»
	'''
		
	def dispatch expand (FileSection fs) {}

	def dispatch expand (TextSection ts) {
		ts.text.expandStrings
	}
	
	def dispatch expand (Clazz c) {
		'''
		«c.sourceProlog.expandStrings»
		«FOR e:c.elements.filterConstructors.sortBy(e|e.parameters.size)»«e.expand»
		«ENDFOR»
		«FOR e:c.elements.filterDestructors»«e.expand»
		«ENDFOR»
		«FOR e:c.elements.filterMethods.sortBy(e|e.name)»«e.expand»
		«ENDFOR»
		«FOR e:c.elements.filter(typeof(Clazz)).sortBy(a|a.name)»«e.expand»
		«ENDFOR»
		«c.sourceEpilog.expandStrings»
		'''		
	}

	def filterConstructors (List<ClassElement> list) {
		list.filter(typeof(Constructor)).filter(a|!a.isInline && !(a.clazz instanceof TemplateClazz))
	}
	
	def filterDestructors (List<ClassElement> list) {
		list.filter(typeof(Destructor)).filter(a|!a.isInline && !a.isAbstract  && !(a.clazz instanceof TemplateClazz))
	}
	
	def filterMethods (List<ClassElement> list) {
		list.filter(typeof(Method)).filter(a|!a.isInline && !a.isAbstract  && !(a.clazz instanceof TemplateClazz))
	}
	
	def String headerFileName (Clazz c) {
		if (c.headerFile != null)
			c.headerFile.name
		else
			headerFileName (c.eContainer as Clazz)
	}
	
	def expand (Constructor c) {
		includeManager.add ('''"«c.clazz.headerFileName»"'''.toString)
		includeManager.add (c.includes)
		'''
		
		«c.sourceProlog.expandStrings»
		«c.expandComment»
		// «c.accessControl»
		«c.clazz.FQN»::«c.clazz.name» («c.parameters.expandParameters»)«c.expandInitializers»
		{
			«c.body.expandStrings»
		}
		«c.sourceEpilog.expandStrings»
		'''		
	}
	
	def expand (Destructor d) {
		includeManager.add ('''"«d.clazz.headerFileName»"'''.toString)
		includeManager.add (d.includes)
		'''
		
		«d.sourceProlog.expandStrings»
		«d.expandComment»
		// «d.accessControl»«if (d.isVirtual) " virtual"»
		«d.clazz.FQN»::~«d.clazz.name» ()
		{
			«d.body.expandStrings»
		}
		«d.sourceEpilog.expandStrings»
		'''
	}
	
	def expand (Method m) {
		includeManager.add ('''"«m.clazz.headerFileName»"'''.toString)
		includeManager.add (m.includes)
		'''
		
		«m.sourceProlog.expandStrings»
		«m.expandComment»
		// «m.accessControl»«if (m.isVirtual) "virtual"»«if (m.isStatic) "static"»
		«if (m.returnType != null) m.returnType.expandType else "void"» «m.clazz.FQN»::«m.name» («m.parameters.expandParameters»)«if (m.isConst) " const"»
		{
			«m.body.expandStrings»
		}
		«m.sourceEpilog.expandStrings»
		'''		
	}
	
	def expandInitializers (Constructor c) {
		val List<String> initializers = newArrayList();
		
		initializers.addAllIfNotNull (c.clazz.baseClasses.map ([initializer(c)]))
		initializers.addAllIfNotNull (c.clazz.fields.map ([initializer(c)]))

		if (initializers.size > 0) {
			'''«FOR s:initializers BEFORE " :\n" SEPARATOR ",\n"»«"\t"»«s»«ENDFOR»'''
		}
	}
	
	def dispatch initializer (BaseClass bc, Constructor c) {
		val initializer = c.initializers.filter(typeof(BaseClassInitializer)).findFirst([ baseClass == bc]);
		if (initializer != null) {
			'''«initializer.baseClass.type.FQN» («initializer.initializer»)'''.toString
		} else {
			if (bc.defaultInitializer != null)
				bc.type.FQN + " (" + bc.defaultInitializer + ")"
		}
	}

	def dispatch initializer (Field f, Constructor c) {
		val initializer = c.initializers.filter(typeof(FieldInitializer)).findFirst([ field == f]);
		if (initializer != null) {
			'''«initializer.field.name» («initializer.initializer»)'''.toString
		} else {
			if (f.defaultInitializer != null)
				f.name + " (" + f.defaultInitializer + ")"
		}
	}

	def <T> addAllIfNotNull (Collection<T> c, Iterable<T> elements) {
		c.addAll (elements.filter ( [ it != null ] ))
	}

}