package org.ckulla.modelingutils.graphviz.ui;

import java.io.File;
import java.util.List;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.resources.IFile;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.ckulla.modelingutils.graphviz.EcoreToGraph;
import org.ckulla.modelingutils.graphviz.GraphToDot;
import org.ckulla.modelingutils.graphviz.graph.Graph;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.handlers.HandlerUtil;

import com.google.inject.Guice;
import com.google.inject.Injector;

public class VisualizeEcore extends AbstractHandler {
	
	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		IStructuredSelection selection = (IStructuredSelection) HandlerUtil
				.getActiveMenuSelection(event);
		Object o = selection.getFirstElement();

		if (o instanceof IFile) {
			IFile file = (IFile) o;

			Injector injector = Guice.createInjector ();

			GraphToDot graphToDot = injector.getInstance(GraphToDot.class);
			EcoreToGraph ecoreToGraph = injector.getInstance(EcoreToGraph.class);
			
			ResourceSetImpl rs = new ResourceSetImpl ();
			URI uri = URI.createFileURI (file.getLocation().toString());
			Resource r = rs.getResource(uri, true);
			List<Graph> graphs = ecoreToGraph.toGraph((EPackage) r.getContents().get(0));
			graphToDot.runDot(new File (uri.toFileString()).getParentFile(), graphs, ((EPackage) r.getContents().get(0)).getName(), "png");		
		}
		return o;
	}
	
}
