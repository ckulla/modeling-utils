package org.ckulla.modelingutils.cppcodegen.generator;

import org.ckulla.modelingutils.cppcodegen.generator.BaseGeneratorTest;
import org.ckulla.modelingutils.cppcodegen.generator.CommentBeautifierTest;
import org.ckulla.modelingutils.cppcodegen.generator.ExampleClassTest;
import org.ckulla.modelingutils.cppcodegen.generator.IncludeManagerTest;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

@RunWith(Suite.class)
@SuiteClasses({
	CommentBeautifierTest.class,
	BaseGeneratorTest.class,
	HppGeneratorTest.class,
	CppGeneratorTest.class,
	IncludeManagerTest.class,
	ExampleClassTest.class,
	TemplateTest.class,
	NestedClassesTest.class,
	GeneratorTest.class
})
public class AllTests {
}
