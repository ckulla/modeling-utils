package org.ckulla.modelingutils.graphviz

import org.ckulla.modelingutils.graphviz.graph.Graph
import org.ckulla.modelingutils.graphviz.graph.Edge
import org.ckulla.modelingutils.graphviz.graph.Node
import org.ckulla.modelingutils.graphviz.graph.Element
import com.google.inject.Inject
import org.ckulla.modelingutils.graphviz.graph.util.GraphFactoryXtend

import static org.ckulla.modelingutils.graphviz.AttributeNames.*

import org.ckulla.modelingutils.graphviz.GraphUtils
import org.ckulla.modelingutils.graphviz.util.Pair
import org.ckulla.modelingutils.graphviz.graph.Attribute

class CollapseGraph {
	
	@Inject extension GraphFactoryXtend
	
	@Inject extension GraphUtils

	@Inject extension HashMultiMapHelper
		
	def Element collapse (Graph g, (Graph) => boolean collapseGraph) {
		processEdges (g, collapseGraph)
		thinOutEdges (g)		
		processGraph (g, collapseGraph)
	}
	
	def Element processGraph (Graph g, (Graph) => boolean collapseGraph) {
		if (collapseGraph.apply (g)) {
			toNode (g)
		} else {
			val graphs = g.elements.filter (typeof(Graph)).toList  
			val collapsed = graphs.map [processGraph (collapseGraph)].toList
			g.elements.removeAll (graphs)
			g.elements.addAll (collapsed)
			g
		}
	}
	
	def create node[] toNode (Graph g) {
		attr [ name = SHAPE value = "record" ]
		attr [ name = LABEL value = '''"{«g.label»}"'''.toString ]			
		attr [ name = FILL_COLOR value =" white" ]
		attr [ name = FONT_COLOR value  = "black" ]			
		attr [ name = STYLE value = "filled, bold" ]		
	}	
	
	def name (Graph g) {
		g.attributes.findFirst [ it.name == NAME ]?.value
	}
		
	def processEdges (Graph g, (Graph) => boolean collapseGraph) {
		for (e: g.elements.filter (typeof (Edge)).toList) {
			val head = collapsedNode (e.head, collapseGraph)
			val tail = collapsedNode (e.tail, collapseGraph)
			if (head != e.head || tail != e.tail) {
				if (tail == head) {
					g.elements.remove (e)
				} else {
					g.elements.remove (e)
					e.head = head
					e.tail = tail
					rootGraph (g).elements.add (e)
				}				
			}
		}
		for (graph : g.elements.filter (typeof (Graph)).toList) {
			graph.processEdges (collapseGraph)
		}
	}

	def thinOutEdges (Graph g) {
		// create a multimap with all edges grouped by the same head and tail
		// FIXME: shoud read: val Multimap<Pair<Node,Node>, Edge> edgeMap = HashMultimap::create()
		val edgeMap = createHashMultiMap();
		g.edges.forEach [edgeMap.put(new Pair(it.tail, it.head), it)]
		// get all duplicte edges 
		for (k : edgeMap.keySet.filter [edgeMap.get(it).size()>1]) {			
			val edge = edgeMap.get(k).head
			// create a set of all labels (duplicate labels will be removed)
			val labels = edgeMap.get(k).map [ findAttribute(HEAD_LABEL)?.value].toSet
			val label = '''"«FOR s:labels SEPARATOR "\\n"»«s»«ENDFOR»"'''.toString
			if (edge.findAttribute(HEAD_LABEL) != null)			
				edge.findAttribute(HEAD_LABEL).value = label 
			else
				edge.attributes += attribute [ name = HEAD_LABEL value = label ]
			// keep only the first edge, remove all others
			edgeMap.get(k).drop(1).forEach [
				removeEdge(g)
			]
		}
	}

	def removeEdge (Edge it, Graph g) {
		g.elements.remove (it)
	}
	
	def collapsedNode (Node n, (Graph) => boolean collapseGraph) {
		var graph = n.eContainer() as Graph
		while (graph != null && collapseGraph.apply (graph) == false) {
			graph = graph.eContainer as Graph
		}
		if (graph == null)
			n				
		else {
			// find the upper most graph which is not collapsed
			// our target is then the contained graph which is collapsed
			// (this is the previousGraph)			
			var previousGraph = graph
			while (graph != null && collapseGraph.apply (graph) == true) {
				previousGraph = graph
				graph = graph.eContainer as Graph
			}			
			toNode (previousGraph)			
		}
	}

	def attr (Element it, (Attribute)=>void initializer) {
		it.attributes += attribute(initializer)
	}
	
}