package org.ckulla.modelingutils.graphviz;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.junit.Rule;
import org.junit.rules.TemporaryFolder;

import static org.junit.Assert.*;

import org.ckulla.modelingutils.graphviz.EcoreToGraph;
import org.ckulla.modelingutils.graphviz.GraphToDot;
import org.ckulla.modelingutils.graphviz.graph.Graph;
import org.ckulla.modelingutils.testutils.guice.GuiceRule;
import org.ckulla.modelingutils.testutils.rules.Rules;
import org.ckulla.modelingutils.testutils.rules.RulesTestRunner;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.junit.Test;
import org.junit.runner.RunWith;

import com.google.inject.Inject;

@RunWith(RulesTestRunner.class)
@Rules({GuiceRule.class})
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
		List<Graph> graphs = ecoreToGraph.toGraph((EPackage) r.getContents().get(0));
		graph2Dot.runDot(folder.getRoot(), graphs, ((EPackage) r.getContents().get(0)).getName(), "png");
		assertTrue (new File (folder.getRoot(), "foo.png").exists());
	}
}
