package org.ckulla.xtend2utils.graphviz.java

import java.util.List

class Package {
	 
	String name
	
	List<Class<?>> classes = newArrayList()
	
	List<Package> packages = newArrayList()

	new () {
	}
		
	new (String name) {
		this.name = name
	}

	def getName () {
		name
	}
		
	def getClasses () {
		classes	
	}

	def getPackages () {
		packages
	}
	
}