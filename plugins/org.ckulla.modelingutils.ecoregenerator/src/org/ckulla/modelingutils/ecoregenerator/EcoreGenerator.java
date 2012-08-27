package org.ckulla.modelingutils.ecoregenerator;

import static com.google.common.collect.Lists.newArrayList;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import org.apache.log4j.Logger;
import org.eclipse.emf.codegen.ecore.generator.Generator;
import org.eclipse.emf.codegen.ecore.generator.GeneratorAdapterFactory;
import org.eclipse.emf.codegen.ecore.genmodel.GenBase;
import org.eclipse.emf.codegen.ecore.genmodel.GenModel;
import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage;
import org.eclipse.emf.codegen.ecore.genmodel.generator.GenBaseGeneratorAdapter;
import org.eclipse.emf.codegen.ecore.genmodel.generator.GenModelGeneratorAdapter;
import org.eclipse.emf.codegen.merge.java.JControlModel;
import org.eclipse.emf.codegen.util.ImportManager;
import org.eclipse.emf.common.notify.Adapter;
import org.eclipse.emf.common.util.BasicMonitor;
import org.eclipse.emf.common.util.Diagnostic;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.common.util.WrappedException;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.URIConverter;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.mwe.utils.GenModelHelper;
import org.eclipse.emf.mwe2.ecore.CvsIdFilteringGeneratorAdapterFactoryDescriptor;
import org.eclipse.emf.mwe2.runtime.Mandatory;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowComponent;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;

import com.google.common.base.Function;

public class EcoreGenerator implements IWorkflowComponent {

	private static Logger log = Logger.getLogger(EcoreGenerator.class);
	static {
		EcorePackage.eINSTANCE.getEFactoryInstance();
		GenModelPackage.eINSTANCE.getEFactoryInstance();
	}

	private boolean generateEdit = false;
	private boolean generateEditor = false;
	private boolean generateCustomClasses = false;
	protected List<String> referencedGenModels = newArrayList();
	protected List<String> srcPaths = newArrayList();
	private String genModel;
	
	public void setGenerateEdit(boolean generateEdit) {
		this.generateEdit = generateEdit;
	}
	
	public void setGenerateEditor(boolean generateEditor) {
		this.generateEditor = generateEditor;
	}
	
	public void setGenerateCustomClasses(boolean generateCustomClasses) {
		this.generateCustomClasses = generateCustomClasses;
	}
	
	@Mandatory
	public void addSrcPath(String srcPath) {
		this.srcPaths.add(srcPath);
	}
	
	@Mandatory
	public void setGenModel(String genModel) {
		this.genModel = genModel;
	}
	
	public void preInvoke() {
		ResourceSet resSet = new ResourceSetImpl();
		resSet.getResource(URI.createURI(genModel), true);
		for (String f : referencedGenModels) {
			resSet.getResource (URI.createURI (f), true);
		}
	}
	
	public void postInvoke() {
	}
	
	protected GenModelHelper createGenModelSetup() {
		return new GenModelHelper();
	}

	public void addReferencedGenModelFile(String fileName) {
		referencedGenModels.add (fileName);
	}
	
	public void invoke(IWorkflowContext ctx) {
		ResourceSet resSet = new ResourceSetImpl();
		Resource resource = resSet.getResource(URI.createURI(genModel), true);
		for (String f : referencedGenModels) {
			Resource r = resSet.getResource (URI.createURI (f), true);
			createGenModelSetup().registerGenModel( (GenModel) EcoreUtil.getObjectByType(r.getContents(), GenModelPackage.Literals.GEN_MODEL));
		}
		final GenModel genModel = (GenModel) EcoreUtil.getObjectByType(resource.getContents(), GenModelPackage.Literals.GEN_MODEL);
		genModel.setCanGenerate(true);
		genModel.reconcile();
		createGenModelSetup().registerGenModel(genModel);

		Generator generator = new Generator() {
			@Override
			public JControlModel getJControlModel() {
				return new JControlModel(){
					@Override
					public boolean canMerge() {
						return false;
					}
				};
			}
		};
		log.info("generating EMF code for "+this.genModel);
		generator.getAdapterFactoryDescriptorRegistry().addDescriptor(GenModelPackage.eNS_URI,
				new GeneratorAdapterDescriptor(getTypeMapper()));
		generator.setInput(genModel);

		Diagnostic diagnostic = generator.generate(genModel, GenBaseGeneratorAdapter.MODEL_PROJECT_TYPE,
				new BasicMonitor());

		if (diagnostic.getSeverity() != Diagnostic.OK)
			log.info(diagnostic);

		if (generateEdit) {
			Diagnostic editDiag = generator.generate(genModel, GenBaseGeneratorAdapter.EDIT_PROJECT_TYPE,
					new BasicMonitor());
			if (editDiag.getSeverity() != Diagnostic.OK)
				log.info(editDiag);
		}

		if (generateEditor) {
			Diagnostic editorDiag = generator.generate(genModel, GenBaseGeneratorAdapter.EDITOR_PROJECT_TYPE,
					new BasicMonitor());
			if (editorDiag.getSeverity() != Diagnostic.OK)
				log.info(editorDiag);
		}
	}

	protected Function<String, String> getTypeMapper() {
		return new mapper();
	}

	
	protected final class mapper implements Function<String, String> {
		public String apply(String from) {
			if (from.startsWith("org.eclipse.emf.ecore"))
				return null;
			for(String srcPath: srcPaths) {
				URI createURI = URI.createURI(srcPath+"/"+from.replace('.', '/')+"Custom.java");
				String customClassName = from+"Custom";
				if (URIConverter.INSTANCE.exists(createURI, null)) {
					return customClassName;
				}
				if (from.endsWith("Impl") && generateCustomClasses) {
					generate(from,customClassName,createURI);
					return customClassName;
				}
			}
			return null;
		}
	}
	
	public void generate(String from,String customClassName, URI path) {
		StringBuilder sb =new StringBuilder();
		sb.append(copyright()).append("\n");
		int lastIndexOfDot = customClassName.lastIndexOf('.');
		sb.append("package ").append(customClassName.substring(0, lastIndexOfDot)).append(";\n\n\n");
		sb.append("public class ").append(customClassName.substring(lastIndexOfDot+1)).append(" extends ").append(from).append(" {\n\n");
		sb.append("}\n");
		
		try {
			OutputStream stream = URIConverter.INSTANCE.createOutputStream(path);
			stream.write(sb.toString().getBytes());
			stream.close();
		} catch (IOException e) {
			throw new WrappedException(e);
		}
	}

	protected String copyright() {
		return 	"/*******************************************************************************\n"+
				 "* Copyright (c) 2008 - 2010 itemis AG (http://www.itemis.eu) and others.\n"+
				 "* All rights reserved. This program and the accompanying materials\n"+
				 "* are made available under the terms of the Eclipse Public License v1.0\n"+
				 "* which accompanies this distribution, and is available at\n"+
				 "* http://www.eclipse.org/legal/epl-v10.html\n"+
				 "*******************************************************************************/";
	}



	/**
	 * @author Sven Efftinge - Initial contribution and API
	 */
	protected static class GeneratorAdapterDescriptor extends CvsIdFilteringGeneratorAdapterFactoryDescriptor {
		/**
		 * @author Sebastian Zarnekow - Initial contribution and API
		 */
		private final class CustomImplAwareGeneratorAdapterFactory extends IdFilteringGenModelGeneratorAdapterFactory {
			@Override
			public Adapter createGenClassAdapter() {
				return new IdFilteringGenClassAdapter(this) {
					@Override
					protected void createImportManager(String packageName, String className) {
						importManager = new ImportManagerHack(packageName, typeMapper);
						importManager.addMasterImport(packageName, className);
						if (generatingObject != null)
							((GenBase) generatingObject).getGenModel().setImportManager(importManager);
					}
				};
			}

			@Override
			public Adapter createGenEnumAdapter() {
				return new IdFilteringGenEnumAdapter(this) {
					@Override
					protected void createImportManager(String packageName, String className) {
						importManager = new ImportManagerHack(packageName, typeMapper);
						importManager.addMasterImport(packageName, className);
						if (generatingObject != null)
							((GenBase) generatingObject).getGenModel().setImportManager(importManager);
					}
				};
			}

			@Override
			public Adapter createGenModelAdapter() {
				if (genModelGeneratorAdapter == null) {
					genModelGeneratorAdapter = new GenModelGeneratorAdapter(this) {
						@Override
						protected void createImportManager(String packageName, String className) {
							importManager = new ImportManagerHack(packageName, typeMapper);
							importManager.addMasterImport(packageName, className);
							if (generatingObject != null)
								((GenBase) generatingObject).getGenModel().setImportManager(
										importManager);
						}

					};
				}
				return genModelGeneratorAdapter;
			}

			@Override
			public Adapter createGenPackageAdapter() {
				return new IdFilteringGenPackageAdapter(this) {
					@Override
					protected void createImportManager(String packageName, String className) {
						importManager = new ImportManagerHack(packageName, typeMapper);
						importManager.addMasterImport(packageName, className);
						if (generatingObject != null)
							((GenBase) generatingObject).getGenModel().setImportManager(importManager);
					}
				};
			}
		}

		private Function<String, String> typeMapper;

		protected GeneratorAdapterDescriptor(Function<String,String> typeMapper) {
			this.typeMapper = typeMapper;
		}

		@Override
		public GeneratorAdapterFactory createAdapterFactory() {
			return new CustomImplAwareGeneratorAdapterFactory();
		}
	}

	protected static class ImportManagerHack extends ImportManager {

		private Function<String, String> typeMapper;

		public ImportManagerHack(String compilationUnitPackage, Function<String,String> typeMapper) {
			super(compilationUnitPackage);
			this.typeMapper = typeMapper;
		}

		@Override
		public String getImportedName(String qualifiedName, boolean autoImport) {
			String mapped = typeMapper.apply(qualifiedName);
			if (mapped != null) {
				log.debug("mapping " + qualifiedName + " to " + mapped);
				return super.getImportedName(mapped, autoImport);
			} else
				return super.getImportedName(qualifiedName, autoImport);
		}
	}

}
