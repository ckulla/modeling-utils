package org.ckulla.modelingutils.testutils.rules;

import java.util.ArrayList;
import java.util.List;

import org.junit.internal.runners.statements.InvokeMethod;
import org.junit.rules.MethodRule;
import org.junit.runners.BlockJUnit4ClassRunner;
import org.junit.runners.model.FrameworkMethod;
import org.junit.runners.model.InitializationError;
import org.junit.runners.model.Statement;

public class RulesTestRunner extends BlockJUnit4ClassRunner {

	ReflectionUtil reflectionUtil = new ReflectionUtil ();

	List<MethodRule> rules = new ArrayList<MethodRule> ();

	public RulesTestRunner(Class<?> clazz) throws InitializationError {
		super (clazz);
	}

	public RulesTestRunner(Class<?> clazz, MethodRule... rules) throws InitializationError {
		super (clazz);
		for (MethodRule rule : rules)
			this.rules.add (rule);

	}

	@Override
	protected Statement methodInvoker(FrameworkMethod method, Object test) {
		Statement s = new InvokeMethod (method, test);
		for (MethodRule rule : getRules (test)) {
			s = rule.apply (s, method, test);
		}
		return s;
	}

	protected List<MethodRule> getRules(Object o) {
		List<MethodRule> returnValue = new ArrayList<MethodRule> (rules);
		returnValue.addAll (getRulesAnnotation (o.getClass ()));
		return returnValue;
	}

	private List<MethodRule> getRulesAnnotation(Class<?> clazz) {
		List<Rules> annotations = reflectionUtil.findAllInherited (clazz, Rules.class);
		List<MethodRule> rules = new ArrayList<MethodRule> ();
		for (Rules annotation : annotations) {
			for (Class<? extends MethodRule> c : annotation.value ()) {
				try {
					rules.add (c.newInstance ());
				} catch (InstantiationException e) {
					throw new RuntimeException (e);
				} catch (IllegalAccessException e) {
					throw new RuntimeException (e);
				}
			}
		}
		return rules;
	}

}