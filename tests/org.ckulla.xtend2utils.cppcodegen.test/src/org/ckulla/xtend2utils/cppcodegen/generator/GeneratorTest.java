package org.ckulla.xtend2utils.cppcodegen.generator;

import java.io.File;
import java.io.IOException;

import org.junit.contrib.rules.RulesTestRunner;
import org.junit.contrib.rules.Rules;
import org.junit.contrib.emf.EmfRegistryRule;
import org.junit.contrib.guice.GuiceRule;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.rules.TemporaryFolder;
import org.junit.Rule;

import static junit.framework.Assert.*;

import com.google.inject.Inject;

import org.ckulla.xtend2utils.cppcodegen.generator.Generator;
import org.ckulla.xtend2utils.cppcodegen.cpp.CppModel;

@RunWith(RulesTestRunner.class)
@Rules({ EmfRegistryRule.class, GuiceRule.class })
public class GeneratorTest {

	@Inject Generator generator;

	@Inject ExampleModelProvider modelProvider;
	
	@Rule
	public TemporaryFolder folder = new TemporaryFolder ();
     
	@Test
	public void testGenerator () throws IOException {
		CppModel model = modelProvider.get ();
		generator.setOutputPath (folder.getRoot());
		generator.generateFiles(model);
		
		assertTrue (new File (folder.getRoot(), "ExampleClass.cpp").exists());
		assertTrue (new File (folder.getRoot(), "ExampleClass.hpp").exists());

	}
	
}