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
import org.eclipse.emf.mwe.utils.StandaloneSetup
import org.junit.Before

@RunWith(typeof (RulesTestRunner))
@Rules({ typeof (EmfRegistryRule), typeof(GuiceRule) })
class FooTest {
	
	@Inject
	EcoreToGraph ecoreToGraph
	
	@Inject
	GraphToDot graph2Dot
	
	@Inject 
	StandaloneSetup standaloneSetup
	
	@Test
	def void test() {
		standaloneSetup.setPlatformUri ("..")		
		val rs = new ResourceSetImpl ()
		val r = rs.getResource(URI::createFileURI("model/Foo.ecore"), true)
		val graph = ecoreToGraph.toGraph(r.getContents().get(0) as EPackage)
		assertEquals (
			'''
				digraph "foo" {
				
					graph [ fontname = "arial" ]
					node [ fontname = "arial" ]
					edge [ fontname = "arial" ]
					
					subgraph "cluster_foo" {
						label="foo";name="foo";fontname="arial";
						
						0 [shape=record,label="{\<\<abstract\>\>\nFoo|name: EString\lref barFromOtherEcore: Bar\\[1..*\\]\l}",fillcolor=white,fontcolor=black,style=filled, bold];
						1 [shape=record,label="{\<\<enumeration\>\>\nQux | aLiteral\lanotherLiteral\l}",fillcolor=grey,fontcolor=black,style=filled];
						subgraph "cluster_bar" {
							label="bar";name="bar";fontname="arial";
							
							2 [shape=record,label="{Bar|}",fillcolor=grey,fontcolor=black,style=filled, bold];
						}
						subgraph "cluster_baz" {
							label="baz";name="baz";fontname="arial";
							
							3 [shape=record,label="{Baz|}",fillcolor=grey,fontcolor=black,style=filled, bold];
						}
					}
					2 -> 3 [dir=both,label=baz,arrowtail=diamond,arrowhead=none,weight=50,headlabel="0..1"];
					0 -> 2 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					3 -> 0 [dir=both,label=foo,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					0 -> 3 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					0 -> 1 [dir=both,label=qux,arrowtail=diamond,arrowhead=none,weight=25];
				}
			'''.toString,
			graph2Dot.toDot(graph, "foo").toString
		)
	}

	@Test
	def void testWithoutDataTypes() {
		standaloneSetup.setPlatformUri ("..")		
		val rs = new ResourceSetImpl ()
		val r = rs.getResource(URI::createFileURI("model/Foo.ecore"), true)
		ecoreToGraph.setShowDataTypes(false)
		val graph = ecoreToGraph.toGraph(r.getContents().get(0) as EPackage)
		assertEquals (
			'''
				digraph "foo" {
				
					graph [ fontname = "arial" ]
					node [ fontname = "arial" ]
					edge [ fontname = "arial" ]
					
					subgraph "cluster_foo" {
						label="foo";name="foo";fontname="arial";
						
						0 [shape=record,label="{\<\<abstract\>\>\nFoo|name: EString\lqux: Qux\lref barFromOtherEcore: Bar\\[1..*\\]\l}",fillcolor=white,fontcolor=black,style=filled, bold];
						subgraph "cluster_bar" {
							label="bar";name="bar";fontname="arial";
							
							1 [shape=record,label="{Bar|}",fillcolor=grey,fontcolor=black,style=filled, bold];
						}
						subgraph "cluster_baz" {
							label="baz";name="baz";fontname="arial";
							
							2 [shape=record,label="{Baz|}",fillcolor=grey,fontcolor=black,style=filled, bold];
						}
					}
					1 -> 2 [dir=both,label=baz,arrowtail=diamond,arrowhead=none,weight=50,headlabel="0..1"];
					0 -> 1 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					2 -> 0 [dir=both,label=foo,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					0 -> 2 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
				}
			'''.toString,
			graph2Dot.toDot(graph, "foo").toString
		)
	}
	
	@Test
	def void testFooAndBar() {
		standaloneSetup.setPlatformUri ("..")				
		val rs = new ResourceSetImpl ()
		val rFoo = rs.getResource(URI::createFileURI("model/Foo.ecore"), true)
		val rBar = rs.getResource(URI::createFileURI("model/Bar.ecore"), true)
		val graph = ecoreToGraph.toGraph(
			newArrayList (rFoo.getContents().get(0) as EPackage, rBar.getContents().get(0) as EPackage)
		)
		assertEquals (
			'''
				digraph "fooAndBar" {
				
					graph [ fontname = "arial" ]
					node [ fontname = "arial" ]
					edge [ fontname = "arial" ]
					
					subgraph "cluster_bar" {
						label="bar";name="bar";fontname="arial";
						
						0 [shape=record,label="{Bar|}",fillcolor=grey,fontcolor=black,style=filled, bold];
					}
					subgraph "cluster_foo" {
						label="foo";name="foo";fontname="arial";
						
						1 [shape=record,label="{\<\<abstract\>\>\nFoo|name: EString\lref barFromOtherEcore: Bar\\[1..*\\]\l}",fillcolor=white,fontcolor=black,style=filled, bold];
						2 [shape=record,label="{\<\<enumeration\>\>\nQux | aLiteral\lanotherLiteral\l}",fillcolor=grey,fontcolor=black,style=filled];
						subgraph "cluster_bar" {
							label="bar";name="bar";fontname="arial";
							
							3 [shape=record,label="{Bar|}",fillcolor=grey,fontcolor=black,style=filled, bold];
						}
						subgraph "cluster_baz" {
							label="baz";name="baz";fontname="arial";
							
							4 [shape=record,label="{Baz|}",fillcolor=grey,fontcolor=black,style=filled, bold];
						}
					}
					3 -> 4 [dir=both,label=baz,arrowtail=diamond,arrowhead=none,weight=50,headlabel="0..1"];
					1 -> 3 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					4 -> 1 [dir=both,label=foo,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					1 -> 4 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					1 -> 2 [dir=both,label=qux,arrowtail=diamond,arrowhead=none,weight=25];
				}
			'''.toString,
			graph2Dot.toDot(graph, "fooAndBar").toString
		)
	}
	
	@Test
	def void testShowReferencedResources() {
		standaloneSetup.setPlatformUri ("..")		
		val rs = new ResourceSetImpl ();
		val r = rs.getResource(URI::createFileURI("model/Foo.ecore"), true)
		ecoreToGraph.setShowReferencedResources (true)
		val graph = ecoreToGraph.toGraph(r.getContents().get(0) as EPackage)
		assertEquals (
			'''
				digraph "foo" {
				
					graph [ fontname = "arial" ]
					node [ fontname = "arial" ]
					edge [ fontname = "arial" ]
					
					subgraph "cluster_bar" {
						label="bar";name="bar";fontname="arial";
						
						0 [shape=record,label="{Bar|}",fillcolor=grey,fontcolor=black,style=filled, bold];
					}
					subgraph "cluster_foo" {
						label="foo";name="foo";fontname="arial";
						
						1 [shape=record,label="{\<\<abstract\>\>\nFoo|name: EString\l}",fillcolor=white,fontcolor=black,style=filled, bold];
						2 [shape=record,label="{\<\<enumeration\>\>\nQux | aLiteral\lanotherLiteral\l}",fillcolor=grey,fontcolor=black,style=filled];
						subgraph "cluster_bar" {
							label="bar";name="bar";fontname="arial";
							
							3 [shape=record,label="{Bar|}",fillcolor=grey,fontcolor=black,style=filled, bold];
						}
						subgraph "cluster_baz" {
							label="baz";name="baz";fontname="arial";
							
							4 [shape=record,label="{Baz|}",fillcolor=grey,fontcolor=black,style=filled, bold];
						}
					}
					3 -> 4 [dir=both,label=baz,arrowtail=diamond,arrowhead=none,weight=50,headlabel="0..1"];
					1 -> 3 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					4 -> 1 [dir=both,label=foo,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					1 -> 4 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					1 -> 2 [dir=both,label=qux,arrowtail=diamond,arrowhead=none,weight=25];
					1 -> 0 [dir=both,label=barFromOtherEcore,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="1..*"];
				}
			'''.toString,
			graph2Dot.toDot(graph, "foo").toString
		)
	}
	
}