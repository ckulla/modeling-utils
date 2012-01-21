package org.ckulla.xtend2utils.javacodegen

import org.ckulla.xtend2utils.javacodegen.ImportManager

class XtendImportManager extends ImportManager {
	
	override getImportDeclarations () {
		super.importDeclarations.toString.replaceAll (";","")
	}
	
	override protected normalizeClassName (String s) {
		s
	} 

	override protected normalizeStatic (String s) {
		s.replaceAll ("\\.","::")
	} 
	
}