package org.eclipse.emf.xtendfactory

import org.eclipse.emf.xtendfactory.ImportManager

class XtendImportManager extends ImportManager {
	
	override importDeclarations () {
		super.importDeclarations.toString.replaceAll (";","")
	}
	
	override protected normalizeClassName (String s) {
		s
	} 

	override protected normalizeStatic (String s) {
		s.replaceAll ("\\.","::")
	} 
	
}