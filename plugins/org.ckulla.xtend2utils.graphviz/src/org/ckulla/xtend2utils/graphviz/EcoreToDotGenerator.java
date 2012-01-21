package org.ckulla.xtend2utils.graphviz;

import java.io.File;

import org.apache.log4j.Logger;
import org.ckulla.xtend2utils.emffactory.Generator;
import org.ckulla.xtend2utils.graphviz.graph.Graph;
import org.eclipse.emf.codegen.ecore.genmodel.GenModel;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.mwe2.runtime.Mandatory;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowComponent;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;

import com.google.inject.Guice;
import com.google.inject.Injector;

public class EcoreToDotGenerator implements IWorkflowComponent {

	Logger log = Logger.getLogger (EcoreToDotGenerator.class);
	
	String ecoreModel;
	
	String outputFolder;
	
	String outputFormat = "png";
	
	@Mandatory
	public void setEcoreModel (String s) {
		ecoreModel = s;
	}

	@Mandatory	
	public void setOutputFolder (String s) {
		outputFolder = s;
	}

	public void setOutputFormat (String s) {
		outputFormat = s;
	}
	
	@Override
	public void preInvoke() {
		new ResourceSetImpl().getResource(URI.createURI(ecoreModel), true);
	}

	@Override
	public void invoke(IWorkflowContext ctx) {
		log.info("Generating visualization for " + ecoreModel);
		
		
		ResourceSet resSet = new ResourceSetImpl();
		Resource resource = resSet.getResource(URI.createURI(ecoreModel), true);
		final EPackage _package = (EPackage) resource.getContents().get(0);
		
		Injector injector = Guice.createInjector();		
		final EcoreToGraph generator = injector.getInstance(EcoreToGraph.class);
		Graph graph = generator.toGraph(_package);
		final GraphToDot graphToDot = injector.getInstance(GraphToDot.class);

		if (outputFolder != null) {
			graphToDot.runDot(new File (outputFolder), graph, outputFormat);
		}
	}

	@Override
	public void postInvoke() {
	}

}
