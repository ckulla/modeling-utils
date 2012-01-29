package org.ckulla.xtend2utils.graphviz;

import org.ckulla.xtend2utils.graphviz.graph.Edge;
import org.ckulla.xtend2utils.graphviz.graph.Node;
import org.ckulla.xtend2utils.graphviz.util.Pair;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;

public class HashMultiMapHelper {

	public Multimap<Pair<Node,Node>, Edge> createHashMultiMap () {
		return HashMultimap.create();
	}
	
}
