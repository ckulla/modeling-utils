package org.ckulla.xtend2utils.emffactory

import org.ckulla.xtend2utils.emffactory.ImportManager

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