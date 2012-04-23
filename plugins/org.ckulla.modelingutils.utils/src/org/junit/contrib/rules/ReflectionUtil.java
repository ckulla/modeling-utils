package org.junit.contrib.rules;

import java.lang.annotation.Annotation;
import java.util.List;

public class ReflectionUtil {

	public boolean hasAnnotation(Class<?> clazz, Annotation[] annotations) {
		for (Annotation a : annotations) {
			if (clazz.isInstance (a))
				return true;
		}
		return false;
	}

	public <A extends Annotation> A findInherited(Class<?> clazz, Class<A> annotationType) {
		A annotation = clazz.getAnnotation (annotationType);
		if (annotation != null) {
			return annotation;
		}
		for (Class<?> ifc : clazz.getInterfaces ()) {
			annotation = findInherited (ifc, annotationType);
			if (annotation != null) {
				return annotation;
			}
		}
		Class<?> superClass = clazz.getSuperclass ();
		if (superClass == null || superClass == Object.class) {
			return null;
		}
		return findInherited (superClass, annotationType);
	}

	public <A extends Annotation> List<A> findAllInherited(Class<?> clazz, Class<A> annotationType) {
		List<A> rv = Lists.newArrayList ();
		Class<?> superClass = clazz.getSuperclass ();
		if (superClass != null && superClass != Object.class) {
			rv.addAll (findAllInherited (superClass, annotationType));
		}
		for (Class<?> ifc : clazz.getInterfaces ()) {
			rv.addAll (findAllInherited (ifc, annotationType));
		}
		if (clazz.getAnnotation (annotationType) != null)
			rv.add (clazz.getAnnotation (annotationType));
		return rv;
	}

}
