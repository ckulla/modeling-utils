package org.ckulla.modelingutils.graphviz

import com.google.inject.Inject
import com.google.inject.name.Named

import java.util.List

import org.ckulla.modelingutils.graphviz.graph.util.GraphFactoryXtend

import static org.ckulla.modelingutils.graphviz.AttributeNames.*

import org.ckulla.modelingutils.graphviz.graph.Element
import org.ckulla.modelingutils.graphviz.graph.Node
import org.ckulla.modelingutils.graphviz.graph.Graph
import org.ckulla.modelingutils.graphviz.graph.Edge

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.ENamedElement
import org.ckulla.modelingutils.graphviz.graph.Attribute
import org.eclipse.emf.ecore.util.EcoreUtil
import java.util.Set
import org.eclipse.emf.ecore.EOperation

class EcoreToGraph {

	@Inject extension GraphFactoryXtend 
	
	@Inject(optional=true) @Named("EcoreToGraph.showDataTypes") 	
	boolean showDataTypes = true

	@Inject(optional=true) @Named("EcoreToGraph.showReferencedResources") 	
	boolean showReferencedResources
		
	Set<Resource> resources
	
	Set<Graph> rootGraphs = newHashSet()

	def void setShowDataTypes (boolean enable) {
		showDataTypes = enable
	}
	
	def void setShowReferencedResources (boolean enable) {
		showReferencedResources = enable
	}
	
	def List<Graph> toGraph (List<EPackage> packages) {
		resources = packages.map [ eResource ].toSet
		for (p: packages) {
			EcoreUtil::resolveAll (p)
			rootGraphs.add (createNode(p) as Graph)
		}
		rootGraphs.toList
	}

	def List<Graph> toGraph (EPackage p) {
		toGraph (newArrayList(p))
	}

	def dispatch expand (EAttribute it) {
		'''«name»: «EType.name»«IF it.unsettable» (unsettable)«ENDIF»'''	
	}	

	def dispatch expand (EReference it) {
		'''«if (!containment) "ref "»«name»: «EType.name»\\[«boundsString»\\]'''	
	}

	def dispatch expand (EOperation it) {
		'''«EType?.name» «name»(«FOR p:EParameters»«p.EType?.name» «p.name»«ENDFOR»)«FOR e:EExceptions BEFORE "throws" SEPARATOR " ,"»«e.name»«ENDFOR»'''
	}
		
	def Element node (ENamedElement c) {
		if (!(typeof (EDataType).isAssignableFrom(c.^class)) || showDataTypes) {
			if (resources.contains (c.eResource)) {
				createNode (c)	
			} else {
				System::out.println (c)
				if (showReferencedResources && !(c.eResource.URI.toString == "http://www.eclipse.org/emf/2002/Ecore"))
					createNodeFromOtherResource (c)
			}
		}
	}
	
	def dispatch Element createNode (EPackage p) {
		graph [
			attr [ name = LABEL value = '''«/*\<\<package\>\>\n*/»«p.name»'''.toString]	
			attr [ name = NAME value = p.name ]	
			attr [ name = FONT_NAME value = "arial"]
			
			elements.addIfNotNull (p.EClassifiers.map [ node ])
			elements.addIfNotNull (p.ESubpackages.map [ node ])
			// add all edges resulting from structural features
			for (c : p.classes) {
				elements.addIfNotNull (c.EStructuralFeatures.map [ edge(c) ])
			}
			// add super type edges
			elements.addIfNotNull (
				p.classes.map [ base | (base as EClass).ESuperTypes.map [ superTypeEdge (base as EClass) ] ].flatten)
		]
	}

	def dispatch Element create node [] createNode (EDataType c) {
		attr [ name = SHAPE value = "record" ]
		attr [ name = LABEL value = '''"{«c.name»|}"'''.toString ]			
		attr [ name = FILL_COLOR value =" white" ]
		attr [ name = FONT_COLOR value  = "black" ]
		attr [ name = STYLE value = "filled, bold" ]
	}
		
	def dispatch Element create node [] createNode (EClass c) {
		attr [ name = SHAPE value = "record" ]
		attr [ name = LABEL 
			value = '''"{«if (c.^abstract) "\\<\\<abstract\\>\\>\\n"»«c.name»«expandOperations(c.EOperations)»«expandFeatures(c.structuralFeaturesNotShownAsEdges.toList)»}"'''.toString
		]			
		attr [ name = FILL_COLOR value = if (c.^abstract) "white" else "grey" ]
		attr [ name = FONT_COLOR value  = "black" ]
		attr [ name = STYLE value = "filled, bold" ]
	}
	
	def dispatch Element create node [] createNode (EEnum c) {
		attr [ name = SHAPE value = "record" ]
		attr [ name = LABEL 
			value = '''"{\<\<enumeration\>\>\n«c.name» | «FOR l:c.ELiterals»«l.name»\l«ENDFOR»}"'''.toString
		]			
		attr [ name = FILL_COLOR value = "grey" ]			
		attr [ name = FONT_COLOR value = "black" ]			
		attr [ name = STYLE value = "filled" ]			
	}	
	
	def Element create node [] createNodeFromOtherResource  (ENamedElement c) {
		attributes.addAll (createNode (c).attributes)
		(createNodeFromOtherResource(c.eContainer as EPackage) as Graph).elements.add(it)	
	}

	def Element create graph [] createNodeFromOtherResource  (EPackage p) {
		attr [ name = LABEL value = '''«/*\<\<package\>\>\n*/»«p.name»'''.toString]	
		attr [ name = NAME value = p.name ]	
		attr [ name = FONT_NAME value = "arial"]
		if (p.eContainer != null)
			(createNodeFromOtherResource (p.eContainer as EPackage) as Graph).elements.add (it)
		else
			rootGraphs.add(it)	
	}
	
	def superTypeEdge (EClass base, EClass derived) {
		edge (base,derived) [
			attr [ name = DIR value = "both" ]			
			attr [ name = ARROW_TAIL value = "empty" ]
			attr [ name = ARROW_HEAD value = "none" ]			
			attr [ name = WEIGHT value = "100" ]				
		]
	}

	def dispatch edge (EReference r, EClass c) {
		edge (c, r.EType) [
			attr [ name = DIR value = "both" ]					
			attr [ name = LABEL value = r.name ]								
			attr [ name = ARROW_TAIL 
				value = if (r.containment) "diamond" else "ediamond"
			]
			attr [ name = ARROW_HEAD value = "none" ]			
			attr [ name = WEIGHT 
				value = if (r.containment) "50" else "1"
			]
			attr [ name = HEAD_LABEL value = "\"" + r.boundsString + "\"" ]
		]
	}		 

	def dispatch edge (EAttribute a, EClass c) {
		edge (c, a.EAttributeType) [
			attr [ name = DIR value = "both" ]					
			attr [ name = LABEL value = a.name ]								
			attr [ name = ARROW_TAIL value = "diamond" ]
			attr [ name = ARROW_HEAD value = "none" ]			
			attr [ name = WEIGHT value = "25" ]
		]
	}		 

	def attr (Element it, (Attribute)=>void initializer) {
		it.attributes += attribute(initializer)
	}
	
	/**
	 * Returns all features of of an EClass which are not shown as edges in
	 * the diagram.
	 */
	def structuralFeaturesNotShownAsEdges (EClass c) {
		c.EStructuralFeatures.filter [ edge(it, c) == null ]
	}
	
	def expandFeatures (List<EStructuralFeature> it) {
		'''«IF size>0»|«ENDIF»«FOR f : it»«f.expand»\l«ENDFOR»'''
	}
	
	def expandOperations (List<EOperation> it) {
		'''«IF size>0»|«ENDIF»«FOR o : it»«o.expand»\l«ENDFOR»'''
	}
	
	/**
	 * Returns all contained EClasses from a package
	 */
	def classes (EPackage p) {
		p.EClassifiers.filter(typeof(EClass))
	}
	
	/**
	 * Creates an edge, if tail and head could be mapped to nodes. Otherwise
	 * returns null
	 */
	def edge (EClassifier tail, EClassifier head, (Edge) => void initializer) {
		if (node(tail) != null && node(head) != null) {
			val x = edge [
				it.tail = node(tail) as Node
				it.head = node (head) as Node
			]
			initializer.apply (x)
			x
		}	
	}

	def boundsString (EReference it) {
		if (lowerBound == 0 && upperBound == -1) 
			"*"
		else
			if (lowerBound == upperBound)
				lowerBound
			else
				lowerBound.toString + ".." + if (upperBound == -1) "*" else upperBound
	}
	
	def <T> addIfNotNull (List<T> it, Iterable<? extends T> toAdd) {
		addAll (toAdd.filter [ it != null ])		
	}		 
}