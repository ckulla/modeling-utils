package org.ckulla.modelingutils.graphviz

import static org.junit.Assert.*

import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.ckulla.modelingutils.graphviz.EcoreToGraph
import org.ckulla.modelingutils.graphviz.GraphToDot
import org.junit.Test
import org.junit.contrib.emf.EmfRegistryRule
import org.junit.contrib.guice.GuiceRule
import org.junit.contrib.rules.Rules
import org.junit.contrib.rules.RulesTestRunner
import org.junit.runner.RunWith

import com.google.inject.Inject
import org.ckulla.modelingutils.graphviz.graph.Graph

@RunWith(typeof (RulesTestRunner))
@Rules({ typeof (EmfRegistryRule), typeof(GuiceRule) })
class CollapseGraphTest {
	
	@Inject
	EcoreToGraph ecoreToGraph
	
	@Inject
	GraphToDot graph2Dot
	
	@Inject
	extension CollapseGraph
	
	@Inject
	extension GraphUtils
	
	@Test
	def void test() {
		val rs = new ResourceSetImpl ();
		val r = rs.getResource(URI::createFileURI("model/Foo.ecore"), true);
		val graph = ecoreToGraph.toGraph(r.getContents().get(0) as EPackage)
		assertEquals (
			'''
				digraph "foo" {
				
					graph [ fontname = "arial" ]
					node [ fontname = "arial" ]
					edge [ fontname = "arial" ]
					
					subgraph "cluster_foo" {
						label="foo";name="foo";fontname="arial";
						
						0 [shape=record,label="{\<\<abstract\>\>\nFoo|name: EString\lref barFromOtherEcore: \\[1..*\\]\l}",fillcolor=white,fontcolor=black,style=filled, bold];
						1 [shape=record,label="{\<\<enumeration\>\>\nQux | aLiteral\lanotherLiteral\l}",fillcolor=grey,fontcolor=black,style=filled];
						subgraph "cluster_bar" {
							label="bar";name="bar";fontname="arial";
							
							2 [shape=record,label="{Bar|}",fillcolor=grey,fontcolor=black,style=filled, bold];
						}
						3 [shape=record,label="{baz}",fillcolor= white,fontcolor=black,style=filled, bold];
					}
					0 -> 1 [dir=both,label=qux,arrowtail=diamond,arrowhead=none,weight=25];
					2 -> 3 [dir=both,label=baz,arrowtail=diamond,arrowhead=none,weight=50,headlabel="0..1"];
					3 -> 0 [dir=both,label=foo,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					0 -> 3 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					0 -> 2 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
				}
			'''.toString,
			graph2Dot.toDot(graph.collapse [ name == "baz"] as Graph).toString
		);
	}

}