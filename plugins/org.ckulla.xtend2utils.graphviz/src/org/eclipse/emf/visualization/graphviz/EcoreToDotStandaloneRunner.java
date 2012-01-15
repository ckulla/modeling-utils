package org.eclipse.emf.visualization.graphviz;

import java.io.File;
import java.io.IOException;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

import org.eclipse.emf.visualization.graphviz.graph.Graph;

import com.google.inject.Inject;

public class EcoreToDotStandaloneRunner {

	@Inject
	GraphToDot graphToDot;
	
	@Inject
	EcoreToGraph ecoreToGraph;
	
	private void setup () {
		// EMF Standalone setup
		if (!Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap ().containsKey ("ecore"))
			Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap ().put ("ecore", new EcoreResourceFactoryImpl ());
		if (!Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap ().containsKey ("xmi"))
			Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap ().put ("xmi", new XMIResourceFactoryImpl ());
		if (!EPackage.Registry.INSTANCE.containsKey (EcorePackage.eNS_URI))
			EPackage.Registry.INSTANCE.put (EcorePackage.eNS_URI, EcorePackage.eINSTANCE);
	}
	
	public void ecoreToDot (URI uri, String outputFormat) throws IOException {
		setup ();
		ResourceSetImpl rs = new ResourceSetImpl ();
		Resource r = rs.getResource(uri, true);
		Graph graph = ecoreToGraph.toGraph((EPackage) r.getContents().get(0));
		graphToDot.runDot(new File (uri.toFileString()).getParentFile(), graph, outputFormat);		
	}
}
