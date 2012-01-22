package org.ckulla.xtend2utils.graphviz.java

import com.google.common.collect.Multimap
import com.google.inject.Inject

class PackageUtil {
	
	@Inject
	extension PackageUtilUtil
	
	def toPackages (Iterable<Class<?>> classes) {
		
		val Multimap<String, Class<?>> classMap = createMultimap ()
		classes.forEach [ classMap.put (it.packageName, it) ]

		val root = new Package ()

		for (packageName : classMap.keySet.sort()) {
			val p = createPackage (root, packageName)
			classMap.get (packageName).forEach [ p.classes.add (it) ]
		}
		
		root	
	}

	def Package createPackage (Package p, String packageName) {
		val child = p.packages.findFirst [ packageName.startsWith (name) ]
		if (child != null) {
			createPackage (child, packageName)	
		} else {
			val newPackage = new Package (packageName)
			p.packages.add(newPackage)
			newPackage
		}
	}	
	
	def packageName (Class<?> c) {
		c.name.substring (0, c.name.lastIndexOf("."))
	}
}