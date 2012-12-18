package org.ckulla.modelingutils.graphviz;

import java.util.List;

import com.google.inject.ImplementedBy;

@ImplementedBy(DefaultDotCommandProvider.class)
public interface IDotCommandProvider {

	public List<String> getDotCommand (String ...options);
	
}
