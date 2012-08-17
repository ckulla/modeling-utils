package org.ckulla.modelingutils.graphviz

import com.google.inject.Inject
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EcorePackage$Literals
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.ecore.xcore.XcoreStandaloneSetup
import org.junit.Test
import org.junit.contrib.guice.GuiceRule
import org.junit.contrib.rules.Rules
import org.junit.contrib.rules.RulesTestRunner
import org.junit.runner.RunWith

import static org.junit.Assert.*

@RunWith(typeof (RulesTestRunner))
@Rules({ /*typeof (EmfRegistryRule),*/ typeof(GuiceRule) })
class EnumerationTest {
	
	@Inject
	EcoreToGraph ecoreToGraph
	
	@Inject
	GraphToDot graph2Dot
	
	@Test
	def void test() {
		XcoreStandaloneSetup::doSetup()
		val rs = new ResourceSetImpl ()
		val r = rs.getResource(URI::createFileURI("model/EnumerationTest.xcore"), true)
		val graph = ecoreToGraph.toGraph(EcoreUtil::getObjectByType(r.getContents(), EcorePackage$Literals::EPACKAGE) as EPackage)
		assertEquals ('''
				digraph "foo" {
				
					graph [ fontname = "arial" ]
					node [ fontname = "arial" ]
					edge [ fontname = "arial" ]
					
					subgraph "cluster_EnuemerationTest" {
						label="EnuemerationTest";name="EnuemerationTest";fontname="arial";
						
						0 [shape=record,label="{MyClass}",fillcolor=grey,fontcolor=black,style=filled, bold];
						1 [shape=record,label="{\<\<enumeration\>\>\nMyEnum | foo\lbar\l}",fillcolor=grey,fontcolor=black,style=filled];
					}
					0 -> 1 [dir=both,label=myEnum,arrowtail=diamond,arrowhead=none,weight=25];
				}
			'''.toString,
			graph2Dot.toDot(graph, "foo").toString
		)
	}
	
}