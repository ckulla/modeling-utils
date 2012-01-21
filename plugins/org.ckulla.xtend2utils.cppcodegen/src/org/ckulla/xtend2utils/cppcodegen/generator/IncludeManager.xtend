package org.ckulla.xtend2utils.cppcodegen.generator

import com.google.inject.Inject
import java.util.HashSet
import org.ckulla.xtend2utils.cppcodegen.cpp.AbstractType
import org.ckulla.xtend2utils.cppcodegen.cpp.IncludedType
import org.ckulla.xtend2utils.cppcodegen.cpp.Clazz
import org.ckulla.xtend2utils.cppcodegen.cpp.Enumeration

class IncludeManager {
	
	@Inject HashSet<String> includes
	
	@Inject HashSet<AbstractType> forwardDeclarations
	
	def addForwardDeclarations (Iterable<AbstractType> forwardDeclarations) {
		this.forwardDeclarations.addAll (forwardDeclarations);	
	} 

	def dispatch void add (AbstractType t) {
	}
		
	def dispatch void add (IncludedType t) {
		if (!forwardDeclarations.contains (t))
			includes.add (t.includeFile)
	}

	def dispatch void add (Enumeration e) {		
		add (e.clazz.headerFile.name)
	}
	
	def dispatch void add (Clazz c) {
		if (c.clazz != null)
			add (c.clazz)
		else
			add (c.headerFile.name)
	}
	
	def add (String include) {
		includes.add (include)
	}

	def add (Iterable<String> includes) {
		this.includes.addAll (includes)
	}
		
	def includes () {
		includes.sort.toList;
	}
	
	def removeIncludes (IncludeManager im) {
		includes.removeAll(im.includes)
	}
}