package org.ckulla.modelingutils.graphviz;

import java.io.File;
import java.util.Collection;
import java.util.List;

import org.apache.log4j.Logger;
import org.ckulla.modelingutils.graphviz.graph.Graph;
import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.mwe2.runtime.Mandatory;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowComponent;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;

import com.google.common.collect.Lists;
import com.google.inject.AbstractModule;
import com.google.inject.Guice;
import com.google.inject.Injector;

public class EcoreToDotGenerator implements IWorkflowComponent {

	Logger log = Logger.getLogger (EcoreToDotGenerator.class);
	
	List<String> ecoresModelUris = Lists.newArrayList();

	String name;
	
	String outputFormat = "png";

	String outputFolder;
	
	String dotCommand;
	
	boolean showDataTypes;
	
	boolean showReferencedResources;
	
	@Mandatory
	public void setName (String s) {
		name = s;
	}
	
	@Mandatory
	public void addEcoreModel (String s) {
		ecoresModelUris.add(s);
	}

	@Mandatory
	public void setOutputFolder (String s) {
		outputFolder = s;
	}
	
	public void setOutputFormat (String s) {
		outputFormat = s;
	}

	public void setDotCommand (String s) {
		dotCommand = s;
	}

	/**
	 * Show data types as nodes in the graph
	 * 
	 * @param enable
	 */
	public void setShowDataTypes (boolean enable) {
	 	showDataTypes = enable;
	}
	
	/**
	 * Show nodes from referenced resources (like references to classes 
	 * of an package contained in an other resource).
	 * 
	 * @param enable
	 */
	public void setShowReferencedResources (boolean enable) {
		showReferencedResources = enable;
	}	
	
	@Override
	public void preInvoke() {
		GenModelPackage.eINSTANCE.getClass();	
		for (String s : ecoresModelUris)
			new ResourceSetImpl().getResource(URI.createURI(s), true);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void invoke(IWorkflowContext ctx) {
		ResourceSet resSet = new ResourceSetImpl();
		List<EPackage> ePackages = Lists.newArrayList();
		for (String s : ecoresModelUris) {
			log.info("Generating visualization for ecore " + s);
			Resource resource = resSet.getResource(URI.createURI(s), true);
			ePackages.addAll ((Collection<? extends EPackage>) EcoreUtil.getObjectsByType(resource.getContents(), EcorePackage.Literals.EPACKAGE));
		}
		Injector injector = Guice.createInjector(new AbstractModule() {

			@Override
			protected void configure() {
				if (dotCommand != null)
					bind (IDotCommandProvider.class).toInstance (new IDotCommandProvider() {
						
						@Override
						public String getDotCommand() {
							return dotCommand;
						}
					});
			}
			
		});		
		final EcoreToGraph generator = injector.getInstance(EcoreToGraph.class);
		generator.setShowDataTypes(showDataTypes);
		generator.setShowReferencedResources(showReferencedResources);
		List<Graph> graphs = generator.toGraph(ePackages);
		final GraphToDot graphToDot = injector.getInstance(GraphToDot.class);
		log.info ("outputfolder = " + outputFolder);
		new File (outputFolder).mkdir();
		graphToDot.runDot(new File (outputFolder), graphs, name, outputFormat);
	}

	public String concatIfNotEmpty (String s1, String s2) {
		if (s1 == null || s1.isEmpty())
			return "";
		else
			return s1 + s2;
	}
	
	@Override
	public void postInvoke() {
	}

}
