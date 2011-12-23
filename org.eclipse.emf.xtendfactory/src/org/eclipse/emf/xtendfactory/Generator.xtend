package org.eclipse.emf.xtendfactory

import com.google.inject.Inject
import org.eclipse.emf.codegen.ecore.genmodel.GenPackage
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.codegen.ecore.genmodel.GenModel
import java.io.File
import java.io.FileWriter

class Generator {

 	@Inject 
 	ImportManager importManager

	String outputFolder = "../"

	def setOutputFolder (String s) {
		this.outputFolder = s
	}

	def javaPackage (GenPackage p) {
		p.basePackage + "." + p.ecorePackage.name
	}
	
	def emfFactoryClassName (GenPackage p) {
		importManager.getClassName (javaPackage (p) + "." + p.prefix + "Factory")
	}
	
	def javaClassifierName (EClassifier c, GenPackage p) {
		importManager.getClassName(javaPackage (p) + "." + c.name)
	}	

	def targetClassName (GenPackage p) {
		p.prefix + "FactoryXtend"
	}

	def targetPackageName (GenPackage p) {
		javaPackage (p) + ".util"
	}
	
	def targetFileName (GenPackage p, GenModel m) {
		outputFolder + m.modelDirectory.substring(1) + "/" + targetPackageName(p).replaceAll("\\.","/") + "/" + targetClassName(p) + ".xtend";	
	}
	
	def generateFactory (GenPackage p, GenModel m) {
		val f = new File (targetFileName (p, m));
		f.getParentFile().mkdirs();
		val fw = new FileWriter (f);
		fw.append(expand(p,m));
		fw.close
	}
	
	def dispatch includeClassifier (EClassifier c) {
		false
	}
	
	def dispatch includeClassifier (EClass c) {
		!c.isAbstract
	}
	
	def expand (GenPackage p, GenModel m) {
		importManager.setPackageName (p.targetPackageName)
		
		val factoryClass = 	
			'''
			class «p.targetClassName» {
				
				«FOR c: p.ecorePackage.getEClassifiers().filter[it.includeClassifier]»
				def create«c.name.toFirstUpper»( («c.javaClassifierName(p)») => void initializer) {
					initialize («p.emfFactoryClassName»::eINSTANCE.create«c.name»(), initializer)
				}
				
				«ENDFOR»		
				def <T> T initialize (T t, (T) => void initializer) {
					initializer.apply (t)
					t
				}
			
			}
			'''
		'''	
		«importManager.expand()»
		
		«factoryClass»
		'''
	}	
}