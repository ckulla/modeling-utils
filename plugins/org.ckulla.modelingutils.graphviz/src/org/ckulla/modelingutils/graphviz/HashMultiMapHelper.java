package org.ckulla.modelingutils.graphviz;

import org.ckulla.modelingutils.graphviz.graph.Edge;
import org.ckulla.modelingutils.graphviz.graph.Node;
import org.ckulla.modelingutils.graphviz.util.Pair;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;

public class HashMultiMapHelper {

	public Multimap<Pair<Node,Node>, Edge> createHashMultiMap () {
		return HashMultimap.create();
	}
	
}
