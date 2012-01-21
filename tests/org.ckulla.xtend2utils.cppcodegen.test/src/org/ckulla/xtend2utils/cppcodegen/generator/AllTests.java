package org.ckulla.xtend2utils.cppcodegen.generator;

import org.ckulla.xtend2utils.cppcodegen.generator.BaseGeneratorTest;
import org.ckulla.xtend2utils.cppcodegen.generator.CommentBeautifierTest;
import org.ckulla.xtend2utils.cppcodegen.generator.ExampleClassTest;
import org.ckulla.xtend2utils.cppcodegen.generator.IncludeManagerTest;
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
