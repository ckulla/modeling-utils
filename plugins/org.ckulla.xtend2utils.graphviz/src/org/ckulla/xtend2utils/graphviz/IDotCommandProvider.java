package org.ckulla.xtend2utils.graphviz;

import com.google.inject.ImplementedBy;

@ImplementedBy(DefaultDotCommandProvider.class)
public interface IDotCommandProvider {

	public String getDotCommand ();
	
}
