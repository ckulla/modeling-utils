package org.ckulla.modelingutils.javacodegen

import org.ckulla.modelingutils.javacodegen.ImportManager

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