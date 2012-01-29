package org.ckulla.modelingutils.graphviz

import com.google.inject.Inject

import java.util.List

import java.io.File
import java.io.FileWriter

import org.ckulla.modelingutils.graphviz.graph.Graph
import org.ckulla.modelingutils.graphviz.graph.Edge
import org.ckulla.modelingutils.graphviz.graph.Node
import org.ckulla.modelingutils.graphviz.graph.Attribute
import org.ckulla.modelingutils.graphviz.graph.Element

import org.ckulla.modelingutils.graphviz.util.CommandExecutor

import static org.ckulla.modelingutils.graphviz.AttributeNames.*

class GraphToDot {
	
	@Inject CommandExecutor executor
	
	int id_
	
	@Inject
	IDotCommandProvider dotCommandProvider
	
	def runDot (File outputPath, Graph g, String outputFormat) {
		val outputFile = toFile (outputPath, g)
		executor.execute(
			newArrayList (
				dotCommandProvider.dotCommand, 
				"-Gcharset=latin1",
				"-T" + outputFormat, 
				"-o" + g.get(NAME)+ "." + outputFormat, 
				outputFile.canonicalPath),  
			null, 
			outputPath.canonicalFile);
	}
	
	def toFile (File path, Graph g) {
		val outputFile = new File (path, g.get(NAME)+".dot")
		val writer = new FileWriter (outputFile)
		writer.write(toDot (g).toString)
		writer.close
		outputFile
	}
	
	def toDot (Graph it) {
		'''
		digraph "«get(NAME)»" {
		
			«IF get(FONT_NAME) != null»
			graph [ fontname = "«get(FONT_NAME)»" ]
			node [ fontname = "«get(FONT_NAME)»" ]
			edge [ fontname = "«get(FONT_NAME)»" ]
			«ENDIF»
			
			«it.expand»
			«it.edges»
		}
		'''
	}

	def dispatch expand (Graph it) {
		'''
		subgraph "cluster_«get(NAME)»" {
			«FOR a:attributes»«a.name»="«a.value»";«ENDFOR»
			
			«FOR e: elements»
			«expand(e)»
			«ENDFOR»
		}
		'''
	}
		
	def dispatch expand (Node it) {
		'''
		«id» «expand(attributes)»;
		'''	
	}

	def dispatch expand (Edge it) {
		''''''
	}

	def dispatch edges (Graph g) {
		'''
		«FOR e: g.elements»«edges(e)»«ENDFOR»
		'''	
	}

	def dispatch edges (Edge it) {
		'''«tail.id» -> «head.id» «expand(attributes)»;
		'''
	}

	def dispatch edges (Node it) {
		''''''
	}
		
	def expand (List<Attribute> attributes) {
		'''[«FOR a:attributes SEPARATOR ","»«a.name»=«a.value»«ENDFOR»]'''
	}

	def get (Element e, String name) {
		e.attributes.findFirst [ it.name == name ]?.value
	}

	def create result: new Integer (id_) id (Element e) {
		id_ = id_ + 1
	}
}