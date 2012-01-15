package org.eclipse.emf.visualization.graphviz;

import com.google.inject.ImplementedBy;

@ImplementedBy(DefaultDotCommandProvider.class)
public interface IDotCommandProvider {

	public String getDotCommand ();
	
}
