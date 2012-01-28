package org.ckulla.xtend2utils.graphviz

import org.ckulla.xtend2utils.graphviz.graph.Element
import org.ckulla.xtend2utils.graphviz.graph.Graph
import org.eclipse.xtext.EcoreUtil2

import static org.ckulla.xtend2utils.graphviz.AttributeNames.*
import org.ckulla.xtend2utils.graphviz.graph.Edge

class GraphUtils {
	
	def getName (Element it) {
		findAttribute(NAME)?.value
	}

	def setName (Element it, String name) {
		findAttribute(NAME).value = name
	}

	def getLabel (Element it) {
		findAttribute(LABEL)?.value
	}

	def findAttribute (Element e, String attribute) {
		e.attributes.findFirst [ it.name == attribute ]
	}	
	
	def Element find(Graph g, (Element) => boolean expression) {
		for (e : g.elements) {
			if (expression.apply(e)) {
				return e
			}
			if (e instanceof Graph) {
				val result = find (e as Graph, expression)
				if (result != null)
					return result;
			}
		}
		null
	}
	
	def Graph rootGraph (Graph g) {
		if (g.eContainer() instanceof Graph) 
			rootGraph (g.eContainer() as Graph)
		else
			g
	}
	
	def edges (Graph g) {
		EcoreUtil2::getAllContentsOfType (g, typeof (Edge))
	}
	
}