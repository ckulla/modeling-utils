package org.ckulla.modelingutils.cppcodegen.generator;

import java.io.File;
import java.io.IOException;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.rules.TemporaryFolder;
import org.junit.Rule;

import static junit.framework.Assert.*;

import com.google.inject.Inject;

import org.ckulla.modelingutils.cppcodegen.generator.Generator;
import org.ckulla.modelingutils.cppcodegen.cpp.CppModel;
import org.ckulla.modelingutils.testutils.emf.EmfRegistryRule;
import org.ckulla.modelingutils.testutils.guice.GuiceRule;
import org.ckulla.modelingutils.testutils.rules.Rules;
import org.ckulla.modelingutils.testutils.rules.RulesTestRunner;

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