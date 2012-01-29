package org.ckulla.modelingutils.graphviz.java

import com.google.inject.Inject
import java.util.List
import org.ckulla.modelingutils.graphviz.graph.Edge
import org.ckulla.modelingutils.graphviz.graph.Element
import org.ckulla.modelingutils.graphviz.graph.Graph
import org.ckulla.modelingutils.graphviz.graph.Node
import org.ckulla.modelingutils.graphviz.graph.util.GraphFactoryXtend

import static org.ckulla.modelingutils.graphviz.AttributeNames.*
import java.lang.reflect.Field

class JavaToGraph {

	@Inject extension GraphFactoryXtend
	
	@Inject extension ReflectionUtil reflectionUtil

	@Inject PackageUtil packageUtil

	String packageName
	
	def Graph toGraph (String packageName) {
		this.packageName = packageName
		val classes = reflectionUtil.getClasses (packageName)
		val rootPackage = packageUtil.toPackages(classes)
		graph (rootPackage.packages.get(0))
	}

	def Graph graph (Package p) {
		graph [
			attribute [ name = LABEL value = p.name ]	
			attribute [ name = NAME value = p.name ]	
			attribute [ name = FONT_NAME value = "arial"]

			val classes = p.classes.sortBy [ name ]
			elements.addIfNotNull 
				(classes.map [ node ])
			elements.addIfNotNull
				(p.packages.sortBy[ name ].map [ graph ] )
			elements.addIfNotNull 
				(classes.map [ c | extendsEdge (c, c.superclass) ])
			elements.addIfNotNull 
				(classes.map [ c | c.interfaces.sortBy[ name ].map [ implementsEdge (c) ]].flatten)
			elements.addIfNotNull
				(classes.map [ c | c.declaredFields.sortBy[ name ].map [ referenceEdge(c) ] ].flatten)
		]
	}

	
	def node (Class<?> c) {
		if (c != null &&
			c.name.startsWith (packageName) &&  
			!c.anonymousClass && 
			c.simpleName != "" && 
			c.name != "java.lang.Object" &&
			!c.simpleName.endsWith ("Test") && 
			!c.simpleName.endsWith ("Tests")
		)
			if (c.interface) 
				interfaceNode (c)
			else
				classNode (c)
	}
	
	def Element create node [] classNode (Class<?> c) {
		attribute [ name = SHAPE value = "record" ]
		attribute [ name = LABEL value = "\"{" +
			(if (c.modifiers.abstract) "\\<\\<abstract\\>\\>\\n" else "") + 
			c.simpleName + "|" +
			c.declaredMethods.expandMethods + "|" +
			c.declaredFields.filter[ it.referenceEdge(c) == null ].expandFields +
			"}\""
		]			
		attribute [ name = FILL_COLOR value =" grey" ]
		attribute [ name = FONT_COLOR value  = "black" ]
		attribute [ name = STYLE value = "filled, bold" ]		
	}

	def Element create node [] interfaceNode (Class<?> c) {
		attribute [ name = SHAPE value = "record" ]
		attribute [ name = LABEL value = "\"{" +
			(if (c.interface) "\\<\\<interface\\>\\>\\n" else "") + 
			c.simpleName + "|" +
			c.declaredMethods.expandMethods + 
			"}\""
		]			
		attribute [ name = FILL_COLOR value =" white" ]
		attribute [ name = FONT_COLOR value  = "black" ]
		attribute [ name = STYLE value = "filled, bold" ]		
	}
		
	def extendsEdge (Class<?> base, Class<?> derived) {
		edge (base,derived) [
			attribute [ name = DIR value = "both" ]			
			attribute [ name = ARROW_TAIL value = "empty" ]
			attribute [ name = ARROW_HEAD value = "none" ]			
			attribute [ name = WEIGHT value = "100" ]
		]
	}

	def implementsEdge (Class<?> base, Class<?> derived) {
		edge (base,derived) [
			attribute [ name = DIR value = "both" ]			
			attribute [ name = ARROW_TAIL value = "empty" ]
			attribute [ name = ARROW_HEAD value = "none" ]			
			attribute [ name = WEIGHT value = "50" ]							
		]
	}

	def referenceEdge (Field f, Class<?> c) {
		edge (f.type, c) [
			attribute [ name = DIR value = "both" ]			
			attribute [ name = ARROW_TAIL value = "none" ]
			attribute [ name = ARROW_HEAD value = "diamond" ]			
			attribute [ name = TAIL_LABEL value = f.name ]			
			attribute [ name = WEIGHT value = "50" ]	
			attribute [ name = "labeldistance" value = "3" ]															
		]
	}
		
	def expandMethods (Iterable<java.lang.reflect.Method> methods) {
		'''«FOR it:methods.filter[!name.startsWith("_")].sortBy[name]»«expand»\l«ENDFOR»'''
	}
	
	def expand (java.lang.reflect.Method it) {
		'''«expandAccessControl» «name» «expandParameterList» «expandReturnType» «expandExceptions»'''
	}

	def expandAccessControl (java.lang.reflect.Method it) {
	}

	def expandReturnType (java.lang.reflect.Method it) {
		": " + expand(genericReturnType)
	}

	def dispatch expand (java.lang.reflect.Type type) {
			
	}

	def dispatch expand (Class<?> clazz) {
		clazz.simpleName
	}

	def expandParameterList (java.lang.reflect.Method m) {
		'''(«FOR p:m.parameterTypes SEPARATOR ", "»«p.expand»«ENDFOR»)'''
	}

	def expandExceptions (java.lang.reflect.Method it) {
	}
	
	def expandFields (Iterable<java.lang.reflect.Field> fields) {
		'''«FOR it:fields.filter[!name.startsWith("_")]»«genericType.expand» «name»\l«ENDFOR»'''
	}
	
	def commaSeparated (Iterable<String> i) {
		'''«FOR s : i SEPARATOR ", "»«s»«ENDFOR»'''
	}
	
	/**
	 * Creates an edge, if tail and head could be mapped to nodes. Otherwise
	 * returns null
	 */
	def edge (Class<?> tail, Class<?> head, (Edge) => void initializer) {
		if (node(tail) != null && node(head) != null) {
			val x = edge [
				it.tail = node(tail) as Node
				it.head = node (head) as Node
			]
			initializer.apply (x)
			x
		}	
	}
	
	def <T> addIfNotNull (List<T> it, Iterable<? extends T> toAdd) {
		addAll (toAdd.filter [ it != null ])		
	}		 
	
}