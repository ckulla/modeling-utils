package org.eclipse.emf.xtendfactory

import org.eclipse.emf.xtendfactory.ImportManager

class XtendImportManager extends ImportManager {
	
	override expand () {
		super.expand().toString().replaceAll (";","")
	}
	
}