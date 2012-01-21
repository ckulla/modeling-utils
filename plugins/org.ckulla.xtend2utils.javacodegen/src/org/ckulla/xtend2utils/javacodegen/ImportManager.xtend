package org.ckulla.xtend2utils.javacodegen

import java.util.Set

/**
 * <p>An import manager keeps track of imported classes during java code generation. 
 * Whenever you want to refer to a java class you have to call the importedName() 
 * method with the fully qualified name of the class. The import manager tries to
 * add the class to the list of imported names (and checks conflicts with already
 * imported classes). It will return either the fully qualified name or the shortend 
 * name due to an import statement.</p>
 *
 * <p>The import manager supports static imports as well. Use the method 
 * staticImportedName() instead. You can preregister static imports by calling 
 * addStaticImport() (for example call addStaticImport ("org.junit.Assert.*"), 
 * staticImportedName("org.junit.Assert.assertEquals") will then return just
 * "assertEquals").</p>
 * 
 * <p>You have to initialize an import manager by calling setPackageName() and 
 * setClassName().</p>
 * 
 * <p>You can get the import section of the java file later on by calling 
 * getImportDeclarations().</p>
 */
class ImportManager {

	String packageName

	String className
	
	Set<String> importedClasses = newHashSet()
	
	Set<String> implicitClasses = newHashSet()

	Set<String> staticImports = newHashSet()
		
	def setPackageName (String packageName) {
		this.packageName = packageName
	}	

	def getPackageName () {
		packageName
	}	
	
	def setClassName (String className) {
		this.className = className
		implicitClasses.add (packageName + "." + className)
	}

	def getClassName () {
		className
	}	

	def addStaticImport (String staticImport) {
		staticImports.add (staticImport)
	}
	
	def importedName(String qualifiedName) {
		getImportedName(qualifiedName)
	}

	def staticImportedName(String qualifiedName) {
		getStaticImportedName(qualifiedName)
	}
	
	def String getStaticImportedName(String qualifiedName) {
		if (isStaticallyImported (qualifiedName) || 
			isStaticallyImported (qualifiedName.packageName + ".*")) {
			qualifiedName.lastSegment
		} else {
			if (staticImports.exists [ lastSegment == qualifiedName.lastSegment]) {
				qualifiedName.normalizeStatic
			} else {
				if (qualifiedName.withoutLastSegment != packageName + "." + className)
					staticImports.add (qualifiedName)
				qualifiedName.lastSegment			
			} 
		}
	}
	
	def String getImportedName(String qualifiedName) {
		if (qualifiedName.contains ("$")) {
			return 
				if (isQuailfiedNameImported(qualifiedName.replaceAll ("\\$", ".")))
					getImportedName(qualifiedName.replaceAll ("\\$", "."))
				else
					normalizeClassName (getImportedName (qualifiedName.withoutInner) + "$" + qualifiedName.inner)
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
	
	def protected normalizeClassName (String s) {
		s.replaceAll ("\\$", ".")
	} 

	def protected normalizeStatic (String s) {
		s
	} 
	
	/**
	 * Returns the import declaration section that should be added to the generated
	 * file.
	 * 
	 * <p>The imports are sorted by package name and class name. An additional empty line
	 * is inserted between packages.</p> 
	 */
	def getImportDeclarations () {
		'''«FOR s:newArrayList (nonStaticImports(), staticImports()).filter[it.length>0] SEPARATOR System::getProperty("line.separator")»«s»«ENDFOR»'''
	}

	def protected nonStaticImports () {	
		'''
		«FOR p:importedClasses.map [ it.packageName ].toSet.sort SEPARATOR System::getProperty("line.separator")»
		«FOR c:importedClasses.filter [ it.packageName == p ].sort»
		import «c»;
		«ENDFOR»
		«ENDFOR»
		'''
	}

	def protected staticImports () {
		'''
		«FOR p:staticImports.map [ it.packageName ].toSet.sort SEPARATOR System::getProperty("line.separator")»
		«FOR c:staticImports.filter [ it.packageName == p ].sort»
		import static «c»;
		«ENDFOR»
		«ENDFOR»
		'''				
	}	
	
	def protected packageName (String qualifiedName) {
		qualifiedName.substring(0, qualifiedName.lastIndexOf("."));	
	}

	def protected className (String qualifiedName) {
		qualifiedName.lastSegment
	}

	def protected lastSegment (String qualifiedName) {
		qualifiedName.substring(qualifiedName.lastIndexOf(".")+1);
	}

	def protected withoutLastSegment (String qualifiedName) {
		qualifiedName.substring(0, qualifiedName.lastIndexOf("."));
	}
	
	def protected withoutInner (String qualifiedName) {
		if (qualifiedName.contains ("$")) {
			qualifiedName.substring (0, qualifiedName.indexOf ("$"))
		} else {
			qualifiedName
		}
	}

	def protected inner (String qualifiedName) {
		if (qualifiedName.contains ("$")) {
			qualifiedName.substring (qualifiedName.indexOf ("$")+1)
		} else {
			qualifiedName
		}		
	}
	
	def protected isInPackage (String qualifiedName, String packageName) {
		packageName (qualifiedName) == packageName
	}
	
	def protected isClassImported (String className) {
		implicitClasses.exists [ it.className == className ] ||
		importedClasses.exists [ it.className == className ]			
	}

	def protected isQuailfiedNameImported (String qualifiedName) {
		implicitClasses.exists [ it == qualifiedName ] ||
		importedClasses.exists [ it == qualifiedName ]			
	}

	def protected isStaticallyImported (String qualifiedName) {
		staticImports.exists [ it == qualifiedName ]
	}

}