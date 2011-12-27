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

	def String getImportedName(String qualifiedName) {
		if (qualifiedName.contains ("$")) {
			return 
				if (isQuailfiedNameImported(qualifiedName.replaceAll ("\\$", ".")))
					getImportedName(qualifiedName.replaceAll ("\\$", "."))
				else
					normalize (getImportedName (qualifiedName.withoutInner) + "$" + qualifiedName.inner)
		} else {
			if (isClassImported (className (qualifiedName))) {			
				if (isQuailfiedNameImported(qualifiedName))
					return className (qualifiedName)
				else
					return qualifiedName
			} else {
				if (isInPackage (qualifiedName, packageName)) 			
					implicitClasses.add (qualifiedName.withoutInner)
				else
					importedClasses.add (qualifiedName.withoutInner)				
				return className (qualifiedName)		
			}
		}
	}
	
	def protected normalize (String s) {
		s.replaceAll ("\\$", ".")
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

	def withoutInner (String qualifiedName) {
		if (qualifiedName.contains ("$")) {
			qualifiedName.substring (0, qualifiedName.indexOf ("$"))
		} else {
			qualifiedName
		}
	}

	def inner (String qualifiedName) {
		if (qualifiedName.contains ("$")) {
			qualifiedName.substring (qualifiedName.indexOf ("$")+1)
		} else {
			qualifiedName
		}		
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