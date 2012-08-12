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
	
	def runDot (File outputPath, List<Graph> graphs, String name, String outputFormat) {
		val outputFile = toFile (outputPath, graphs, name)
		executor.execute(
			newArrayList (
				dotCommandProvider.dotCommand, 
				"-Gcharset=latin1",
				"-T" + outputFormat, 
				"-o" + name + "." + outputFormat, 
				outputFile.canonicalPath),  
			null, 
			outputPath.canonicalFile);
	}
	
	def toFile (File path, Graph g) {
		toFile (path, newArrayList(g), g.get(NAME))
	}

	def toFile (File path, List<Graph> graphs, String name) {
		val outputFile = new File (path, name + ".dot")
		val writer = new FileWriter (outputFile)
		writer.write(toDot (graphs, name).toString)
		writer.close
		outputFile
	}
	
	def toDot (List<Graph> it, String name) {
		'''
		digraph "«name»" {
		
			«IF head.get(FONT_NAME) != null»
			graph [ fontname = "«head.get(FONT_NAME)»" ]
			node [ fontname = "«head.get(FONT_NAME)»" ]
			edge [ fontname = "«head.get(FONT_NAME)»" ]
			«ENDIF»
			
			«FOR g:it.sortBy[get(NAME)]»«g.expand»«ENDFOR»
			«FOR g:it.sortBy[get(NAME)]»«g.edges»«ENDFOR»
		}
		'''
	}

	def dispatch expand (Graph it) {
		'''
		subgraph "cluster_«get(NAME)»" {
			«FOR a:attributes»«a.name»="«a.value»";«ENDFOR»
			
			«FOR e: elements»
			«e.expand»
			«ENDFOR»
		}
		'''
	}
		
	def dispatch expand (Node it) {
		'''
		«id» «expandAttributes(attributes)»;
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
		'''«tail.id» -> «head.id» «expandAttributes(attributes)»;
		'''
	}

	def dispatch edges (Node it) {
		''''''
	}
		
	def expandAttributes (List<Attribute> attributes) {
		'''[«FOR a:attributes SEPARATOR ","»«a.name»=«a.value»«ENDFOR»]'''
	}

	def get (Element e, String name) {
		e.attributes.findFirst [ it.name == name ]?.value
	}

	def create result: new Integer (id_) id (Element e) {
		id_ = id_ + 1
	}
}