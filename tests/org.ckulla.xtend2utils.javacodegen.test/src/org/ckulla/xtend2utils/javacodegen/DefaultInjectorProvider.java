package org.ckulla.xtend2utils.javacodegen;

import org.eclipse.xtext.junit4.IInjectorProvider;

import com.google.inject.Guice;
import com.google.inject.Injector;

public class DefaultInjectorProvider implements IInjectorProvider {

	@Override
	public Injector getInjector() {
		return Guice.createInjector();
	}

}
