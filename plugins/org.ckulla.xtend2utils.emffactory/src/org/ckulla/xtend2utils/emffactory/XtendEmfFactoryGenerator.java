package org.ckulla.xtend2utils.emffactory;

import org.eclipse.emf.codegen.ecore.genmodel.GenModel;
import org.eclipse.emf.codegen.ecore.genmodel.GenPackage;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.mwe2.runtime.Mandatory;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowComponent;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.apache.log4j.Logger;

import com.google.inject.Guice;

public class XtendEmfFactoryGenerator implements IWorkflowComponent {

	Logger log = Logger.getLogger (XtendEmfFactoryGenerator.class);

	String genModel;
	
	String outputFolder;
	
	@Mandatory
	public void setGenModel (String s) {
		genModel = s;
	}

	public void setOutputFolder (String s) {
		outputFolder = s;
	}

	@Override
	public void preInvoke() {
		new ResourceSetImpl().getResource(URI.createURI(genModel), true);
	}

	@Override
	public void invoke(IWorkflowContext ctx) {
		ResourceSet resSet = new ResourceSetImpl();
		Resource resource = resSet.getResource(URI.createURI(genModel), true);
		final GenModel genModel = (GenModel) resource.getContents().get(0);
		
		final Generator generator = Guice.createInjector().getInstance(Generator.class);
		if (outputFolder != null) {
			generator.setOutputFolder(outputFolder);
		}
		log.info("Generating Xtend EMF factory code for "+this.genModel);

		for (GenPackage p : genModel.getGenPackages()) {
			log.info("Generating factory for package " +  p.getEcorePackage().getName());
			generator.generateFactory(p, genModel);			
		}
	}

	@Override
	public void postInvoke() {
	}

}
