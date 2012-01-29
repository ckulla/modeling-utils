package org.ckulla.modelingutils.cppcodegen.generator

import com.google.inject.Inject

import java.util.List

import org.ckulla.modelingutils.cppcodegen.cpp.BaseClass
import org.ckulla.modelingutils.cppcodegen.cpp.Clazz
import org.ckulla.modelingutils.cppcodegen.cpp.Constructor
import org.ckulla.modelingutils.cppcodegen.cpp.Destructor
import org.ckulla.modelingutils.cppcodegen.cpp.EAccessControl
import org.ckulla.modelingutils.cppcodegen.cpp.Enumeration
import org.ckulla.modelingutils.cppcodegen.cpp.Field
import org.ckulla.modelingutils.cppcodegen.cpp.HeaderFile
import org.ckulla.modelingutils.cppcodegen.cpp.Method
import org.ckulla.modelingutils.cppcodegen.cpp.Operation
import org.ckulla.modelingutils.cppcodegen.cpp.Struct
import org.ckulla.modelingutils.cppcodegen.cpp.ClassElement
import org.ckulla.modelingutils.cppcodegen.cpp.FileSection
import org.ckulla.modelingutils.cppcodegen.cpp.Namespace
import org.ckulla.modelingutils.cppcodegen.cpp.TemplateClazz
import org.ckulla.modelingutils.cppcodegen.cpp.TextSection
import org.ckulla.modelingutils.cppcodegen.cpp.HeaderTextSection

class HppGenerator {

	@Inject extension BaseGenerator baseGenerator
			
	def getIncludeManager () {
		baseGenerator.includeManager	
	}
	
	def expand (HeaderFile hf) {
		val body = hf.body
		'''
		«hf.fileHeader»
		«includeManager.expand»
		«body»
		«hf.fileFooter»
		'''	
	}	
	
	def fileDefine(HeaderFile hf) {
		hf.name.toUpperCase.replace('.', '_') + '_'
	}
	
	def fileHeader(HeaderFile hf) '''
		#ifndef «hf.fileDefine»
		#define «hf.fileDefine»

		«baseGenerator.fileHeader(hf)»
	'''	
	
	def fileFooter (HeaderFile hf) '''
		«baseGenerator.fileFooter (hf)»
		
		#endif // «hf.fileDefine»
	'''
	
	def body (HeaderFile hf) '''
		«FOR s:hf.sections»«s.expand»«ENDFOR»
	'''

	def dispatch expand (FileSection fs) {
	}

	def dispatch expand (TextSection ts) {
		ts.text.expandStrings
	}
	
	def expand (Namespace namespace, CharSequence body) {
		var rv = '''
		
		namespace «namespace.name» {
			«body»
		}
		'''	
		if (namespace.parent != null) {
			rv = expand (namespace.parent, rv)
		}
		rv
	}
	
	def dispatch expand (Clazz c) {
		includeManager.addForwardDeclarations (c.forwardDeclarations)
		val rv = '''
		«c.headerProlog.expandStrings»
		«FOR fd:c.forwardDeclarations»
		class «fd.FQN»;
		«ENDFOR»
		«IF c.forwardDeclarations.size>0»
		
		«ENDIF»		
		
		«c.expandComment»
		«IF (c instanceof TemplateClazz)»template <«FOR s:(c as TemplateClazz).arguments SEPARATOR ", "»«s.prefix» «s.name»«ENDFOR»>«ENDIF»
		«if (c instanceof Struct) "struct" else "class"» «c.name»«if (c.baseClasses.size>0) baseClassesToText(c.baseClasses)» {
		«c.elements.filter [ accessControl == EAccessControl::PUBLIC ].toList.expandElements»
		«c.elements.filter [ accessControl == EAccessControl::PROTECTED ].toList.expandElements»
		«c.elements.filter [ accessControl == EAccessControl::PRIVATE ].toList.expandElements»
		«FOR e:c.friends»
		
		friend «e.expandType»
		«ENDFOR»		
		
		};
		«c.headerEpilog.expandStrings»
		'''
		if (c.namespace != null) {
			return expand (c.namespace, rv)
		}
		return rv
	}
	
	def expandElements (List<ClassElement> elements) '''
		«IF (elements.size()>0)»«elements.get(0).accessControl.expand»«ENDIF»
			«FOR e:elements.filter(typeof(Field)).sortBy(e|e.name)»

			«e.expand»
			«ENDFOR»
			«FOR e:elements.filter(typeof(Enumeration)).sortBy(e|e.name)»

			«e.expand»
			«ENDFOR»		
			«FOR e:elements.filter(typeof(Constructor)).sortBy(e|e.parameters.size)»

			«e.expand»
			«ENDFOR»
			«FOR e:elements.filter(typeof(Destructor))»

			«e.expand»
			«ENDFOR»
			«FOR e:elements.filter(typeof(Method)).sortBy(e|e.name)»

			«e.expand»
			«ENDFOR»
			«FOR e:elements.filter(typeof(Clazz)).sortBy(e|e.name)»

			«e.expand»
			«ENDFOR»
			«FOR e:elements.filter(typeof(HeaderTextSection))»

			«e.expand»
			«ENDFOR»
	'''
	
	def baseClassesToText (List<BaseClass> baseClasses)
		''' : «FOR b:baseClasses SEPARATOR ", "»«b.accessControl.toString» «expandType(b.type)»«ENDFOR»'''
	
	def expand(EAccessControl ac) {
		return '''
		
		«ac.literal»:
		'''
	}
		
	def expand (Field f) '''
		«f.headerProlog.expandStrings»
		«f.expandComment»
		«f.type.expandType» «f.name»«f.type.expandTypePostfix»;
		«f.headerEpilog.expandStrings»
	'''		
	
	
	def expand (Constructor c) '''
		«c.headerProlog.expandStrings»
		«c.expandComment»
		«c.clazz.name» («c.parameters.expandParameters»)«if (!c.isInline) ";"»
		«IF c.isInline || (c.clazz instanceof TemplateClazz)»
		{
			«c.body.expandStrings»
		}
		«ENDIF»
		«c.headerEpilog.expandStrings»
	'''
	
	def expand (Destructor d) '''
		«d.headerProlog.expandStrings»
		«d.expandComment»
		«if (d.isVirtual) "virtual "»~«d.clazz.name» ()«if (d.isAbstract) " = 0"»«if (!d.isInline) ";"»
		«IF d.isInline || (d.clazz instanceof TemplateClazz)»
		{
			«d.body.expandStrings»
		}
		«ENDIF»
		«d.headerEpilog.expandStrings»
	'''
	
	def expand (Method m) '''
		«m.headerProlog.expandStrings»
		«m.expandComment»
		«m.prefix»«if (m.returnType != null) m.returnType.expandType else "void"» «m.name» («m.parameters.expandParameters»)«m.postfix»
		«IF m.isInline || (m.clazz instanceof TemplateClazz)»
		{
			«m.body.expandStrings»
		}
		«ENDIF»
		«m.headerEpilog.expandStrings»
	'''		

	def expand (HeaderTextSection s) {
		s.text.expandStrings
	}
	
	def prefix (Method m) {
		if (m.isStatic)
			"static "
		else
			if (m.isVirtual)
				"virtual "
			else
				""
	}
	
	def postfix (Method m) {
		var rv = ""
		if (m.isConst)
			rv = rv + " const"
		if (m.isAbstract)
			rv = rv + " = 0"
		if (!m.isInline)
			rv = rv + ";"
		rv
	}
	
	def body (Operation o) {
		includeManager.add(o.includes)
		'''
		{
			«o.body.expandStrings»
		}
		'''
	}
	
	def dispatch expand (Enumeration e) '''
		enum «e.name» {
			«FOR l:e.literals SEPARATOR ","»
			«l.name»«IF (l.value!=null)»= «l.value»«ENDIF»
			«ENDFOR»
		}
	'''	

}