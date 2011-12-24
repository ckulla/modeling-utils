package org.eclipse.emf.xtendfactory

import java.util.Set

class ImportManager {

	String packageName
	
	Set<String> importedClasses = newHashSet()
	
	Set<String> implicitClasses = newHashSet()
	
	def setPackageName (String packageName) {
		this.packageName = packageName
	}	

	def getPackageName () {
		packageName
	}	
	
	def setClassName (String className) {
		implicitClasses.add (packageName + "." + className)
	}

	def getClassName () {
		className
	}	

	def importedName(String qualifiedName) {
		getImportedName(qualifiedName)
	}

	def getImportedName(String qualifiedName) {
		if (isClassImported (className (qualifiedName))) {			
			if (isQuailfiedNameImported(qualifiedName))
				return className (qualifiedName)
			else
				return qualifiedName
		} else {
			if (isInPackage (qualifiedName, packageName)) 			
				implicitClasses.add (qualifiedName)
			else
				importedClasses.add (qualifiedName)				
			return className (qualifiedName)		
		}
	}
	
	/**
	 * Returns the import declaration section that should be added to the generated
	 * file.
	 * 
	 * The imports are sorted by package name and class name. An additional empty line
	 * is inserted between pacakges. 
	 */
	def importDeclarations () {
		'''
		«FOR p:importedClasses.map [ it.packageName ].toSet.sort SEPARATOR System::getProperty("line.separator")»
		«FOR c:importedClasses.filter [ it.packageName == p ].sort»
		import «c»;
		«ENDFOR»
		«ENDFOR»
		'''
	}
	
	def protected packageName (String qualifiedName) {
		qualifiedName.substring(0, qualifiedName.lastIndexOf("."));	
	}

	def protected className (String qualifiedName) {
		qualifiedName.substring(qualifiedName.lastIndexOf(".")+1);	
	}
	
	def protected isInPackage (String qualifiedName, String packageName) {
		packageName (qualifiedName) == packageName
	}
	
	def isClassImported (String className) {
		implicitClasses.exists [ it.className == className ] ||
		importedClasses.exists [ it.className == className ]			
	}

	def isQuailfiedNameImported (String qualifiedName) {
		implicitClasses.exists [ it == qualifiedName ] ||
		importedClasses.exists [ it == qualifiedName ]			
	}
}