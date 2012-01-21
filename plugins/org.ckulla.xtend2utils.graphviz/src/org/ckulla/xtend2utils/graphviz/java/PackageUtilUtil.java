package org.ckulla.xtend2utils.graphviz.java;

import com.google.common.collect.Multimap;
import com.google.common.collect.HashMultimap;

/**
 * This class is a workaround for a problem with the maven xtend2 compiler. When
 * compiling the HashMultimap.create() with maven a "An API incompatibility was 
 * encountered" is thrown.
 * 
 * @author Christoph Kulla
 */
public class PackageUtilUtil {

	public Multimap<String, Class<?>> createMultimap () {
		return HashMultimap.create();
	}
}
