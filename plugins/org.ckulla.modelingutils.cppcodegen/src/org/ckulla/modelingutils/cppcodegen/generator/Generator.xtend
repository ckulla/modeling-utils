package org.ckulla.modelingutils.cppcodegen.generator

import com.google.inject.Inject

import java.io.FileWriter

import org.ckulla.modelingutils.cppcodegen.cpp.SourceFile
import org.ckulla.modelingutils.cppcodegen.cpp.HeaderFile
import org.ckulla.modelingutils.cppcodegen.cpp.CppModel
import org.ckulla.modelingutils.cppcodegen.cpp.File

class Generator {
	
	@Inject CppGenerator cppGenerator

	@Inject HppGenerator hppGenerator
	
	java.io.File outputPath
	
	def dispatch generate (SourceFile sourceFile) {
		cppGenerator.expand (sourceFile)
	}
	
	def dispatch generate (HeaderFile headerFile) {
		hppGenerator.expand (headerFile)
	}

	def setOutputPath (java.io.File path) {
		outputPath = path
	}
	
	def getFile (File file) {
		if (outputPath != null)
			new java.io.File (outputPath, file.name)
		else
			new java.io.File (file.name)
	}
	
	def generateFile (File file) {		
		val writer = new FileWriter (getFile (file));
		writer.write (generate (file).toString)
		writer.close
	}
	
	def generateFiles (CppModel cppModel) {
		for (f : cppModel.files)
			generateFile (f)	
	}
	
}