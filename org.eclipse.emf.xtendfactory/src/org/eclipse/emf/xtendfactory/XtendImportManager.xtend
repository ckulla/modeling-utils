package org.eclipse.emf.xtendfactory

import org.eclipse.emf.xtendfactory.ImportManager

class XtendImportManager extends ImportManager {
	
	override importDeclarations () {
		super.importDeclarations.toString.replaceAll (";","")
	}
	
	override protected normalize (String s) {
		s
	} 
	
}