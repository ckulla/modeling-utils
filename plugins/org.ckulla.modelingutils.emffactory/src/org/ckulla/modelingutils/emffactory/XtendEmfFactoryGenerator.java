package org.ckulla.modelingutils.emffactory;

import org.eclipse.emf.codegen.ecore.genmodel.GenModel;
import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage;
import org.eclipse.emf.codegen.ecore.genmodel.GenPackage;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.util.EcoreUtil;
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
		final GenModel genModel = (GenModel) EcoreUtil.getObjectByType(resource.getContents(), GenModelPackage.Literals.GEN_MODEL);
		
		log.info("Generating Xtend EMF factory code for "+this.genModel);

		for (GenPackage p : genModel.getGenPackages()) {
			doGenerate(p);
		}
	}

	public void doGenerate (GenPackage p) {
		log.info("Generating factory for package " +  getFQPackageName (p.getEcorePackage()));
		createGenerator().generateFactory(p, getGenModel (p));	
		
		for (GenPackage nestedPackage : p.getNestedGenPackages()) {
			doGenerate(nestedPackage);
		}		 
	}

	protected GenModel getGenModel (GenPackage p) {
		EObject o = p;
		while (!(o instanceof GenModel)) {
			o = o.eContainer();
		}
		return (GenModel) o;
	}
	
	protected Generator createGenerator () {
		Generator generator = Guice.createInjector().getInstance(Generator.class);
		if (outputFolder != null) {
			generator.setOutputFolder(outputFolder);
		}
		return generator;
	}
	
	public String getFQPackageName (EPackage p) {
		if (p.eContainer() instanceof EPackage) 
			return getFQPackageName ((EPackage) p.eContainer()) + "." + p.getName();
		else
			return p.getName();
	}
	
	@Override
	public void postInvoke() {
	}

}
