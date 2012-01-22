package org.ckulla.xtend2utils.graphviz;

import java.io.File;

import org.apache.log4j.Logger;
import org.ckulla.xtend2utils.graphviz.graph.Graph;
import org.eclipse.emf.codegen.ecore.genmodel.GenModel;
import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage;
import org.eclipse.emf.codegen.ecore.genmodel.GenPackage;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.mwe2.runtime.Mandatory;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowComponent;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;

import com.google.inject.AbstractModule;
import com.google.inject.Guice;
import com.google.inject.Injector;

public class EcoreToDotGenerator implements IWorkflowComponent {

	Logger log = Logger.getLogger (EcoreToDotGenerator.class);
	
	String genModel;
	
	String outputFormat = "png";

	String outputFolder;
	
	String dotCommand;
	
	@Mandatory
	public void setGenModel (String s) {
		genModel = s;
	}

	public void setOutputFolder (String s) {
		outputFolder = s;
	}
	
	public void setOutputFormat (String s) {
		outputFormat = s;
	}

	public void setDotCommand (String s) {
		dotCommand = s;
	}

	
	@Override
	public void preInvoke() {
		GenModelPackage.eINSTANCE.getClass();		
		new ResourceSetImpl().getResource(URI.createURI(genModel), true);
	}

	@Override
	public void invoke(IWorkflowContext ctx) {
		log.info("Generating visualization for " + genModel);
	
		ResourceSet resSet = new ResourceSetImpl();
		Resource resource = resSet.getResource(URI.createURI(genModel), true);
		final GenModel genModel = (GenModel) resource.getContents().get(0);
		
		for (GenPackage p : genModel.getGenPackages()) {
			log.info("Generating visualization for package " +  p.getEcorePackage().getName());
			
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
			Graph graph = generator.toGraph(p.getEcorePackage());
			final GraphToDot graphToDot = injector.getInstance(GraphToDot.class);
			log.info ("outputfolder = " + getOutputFolder (p));
			new File (getOutputFolder (p)).mkdir();
			graphToDot.runDot(new File (getOutputFolder (p)), graph, outputFormat);

		}		
	}

	public String getOutputFolder (GenPackage p) {
		if (outputFolder == null) {
			GenModel genModel = (GenModel) p.eContainer();	
			return ".." + genModel.getModelDirectory() + "/" + (concatIfNotEmpty(p.getBasePackage(),  "/") + p.getEcorePackage().getName()).replaceAll("\\.","/");
		} else {
			return outputFolder;
		}
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
