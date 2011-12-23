package org.eclipse.emf.xtendfactory

import java.util.Set

class ImportManager {

	String packageName
	
	Set<String> classes
	
	def setPackageName (String packageName) {
		this.packageName = packageName
		this.classes = newHashSet()
	}	
	
	def getClassName (String fqnClassName) {
		if (isInPackage (fqnClassName, packageName)) {
			return className (fqnClassName)
		} else {
			classes.add (fqnClassName);
			return className (fqnClassName)
		}
	}
	
	def expand () {
		'''
		package «packageName»

		«FOR c:classes.sort»
		import «c»
		«ENDFOR»
		'''
	}
	
	def protected packageName (String fqnClassName) {
		fqnClassName.substring(0, fqnClassName.lastIndexOf("."));	
	}

	def protected className (String fqnClassName) {
		fqnClassName.substring(fqnClassName.lastIndexOf(".")+1);	
	}
	
	def protected isInPackage (String fqnClassName, String packageName) {
		packageName (fqnClassName) == packageName
	}	
}