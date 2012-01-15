package org.eclipse.emf.visualization.graphviz;

import java.io.File;
import java.io.IOException;

import org.junit.Rule;
import org.junit.rules.TemporaryFolder;

import static org.junit.Assert.*;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.visualization.graphviz.EcoreToGraph;
import org.eclipse.emf.visualization.graphviz.GraphToDot;
import org.eclipse.emf.visualization.graphviz.graph.Graph;
import org.junit.Test;
import org.junit.contrib.emf.EmfRegistryRule;
import org.junit.contrib.guice.GuiceRule;
import org.junit.contrib.rules.Rules;
import org.junit.contrib.rules.RulesTestRunner;
import org.junit.runner.RunWith;

import com.google.inject.Inject;

@RunWith(RulesTestRunner.class)
@Rules({EmfRegistryRule.class, GuiceRule.class})
public class RunDotTest {

	@Rule
	public TemporaryFolder folder = new TemporaryFolder ();

	@Inject
	EcoreToGraph ecoreToGraph;
	
	@Inject
	GraphToDot graph2Dot;
	
	@Test
	public void test() throws IOException {
		ResourceSetImpl rs = new ResourceSetImpl ();
		Resource r = rs.getResource(URI.createFileURI("model/Foo.ecore"), true);
		Graph graph = ecoreToGraph.toGraph((EPackage) r.getContents().get(0));
		graph2Dot.runDot(folder.getRoot(), graph, "png");
		assertTrue (new File (folder.getRoot(), "foo.png").exists());
	}
}
