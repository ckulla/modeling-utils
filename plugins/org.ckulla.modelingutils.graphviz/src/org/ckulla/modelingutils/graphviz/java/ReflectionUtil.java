package org.ckulla.modelingutils.graphviz.java;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.JarURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import com.google.common.collect.Lists;

public class ReflectionUtil {

	public String getShortName (Class<?> c) {
		String[] strings = c.getName().split("[a-zA-Z][a-zA-z0-9]*\\.");
		return strings[strings.length-1];
	}
	
	public Class<?> getClass(String className) throws ClassNotFoundException {
		return getClass (Thread.currentThread().getContextClassLoader(), className);
	}
	
	
	private Class<?> getClass(ClassLoader contextClassLoader,
			String className) throws ClassNotFoundException {
		return contextClassLoader.loadClass(className);
	}

	public List<Class<?>> getClasses(String packageName) throws ClassNotFoundException {
		return getClasses (Thread.currentThread().getContextClassLoader(), packageName);
	}
	
	// FIXME: add flag whether to get classes from sub packages
	public List<Class<?>> getClasses(ClassLoader cld, String packageName)
			throws ClassNotFoundException {
		// This will hold a list of directories matching the packageName.
		// There may be more than one if a package is split over multiple
		// jars/paths
		List<Class<?>> classes = new ArrayList<Class<?>>();
		ArrayList<File> directories = new ArrayList<File>();
		try {
			// Ask for all resources for the path
			Enumeration<URL> resources = cld.getResources(packageName.replace('.','/'));
			while (resources.hasMoreElements()) {
				URL res = resources.nextElement();
				//res= FileLocator.resolve(res);
				if (res.getProtocol().equalsIgnoreCase("jar")) {
					JarURLConnection conn = (JarURLConnection) res
							.openConnection();
					JarFile jar = conn.getJarFile();
					// System.out.println ("jar:"+jar.getName());
					for (JarEntry e : Collections.list(jar.entries())) {
						if (e.getName().startsWith(packageName.replace('.', '/'))
								&& e.getName().endsWith(".class")
								&& !e.getName().contains("$")) {
							String className = e.getName().replace("/", ".")
									.substring(0, e.getName().length() - 6);
							// System.out.println(className);
							if (className.substring(packageName.length()+1).matches("[a-zA-Z][a-zA-z0-9]*\\.class")) {				
								classes.add(Class.forName(className));
							}
						}
					}
				} else {
					//System.out.println (URLDecoder.decode(res.getPath(), "UTF-8").toString());
					directories.add(new File(URLDecoder.decode(res.getPath(),
							"UTF-8")));
				}
			}
		} catch (NullPointerException x) {
			throw new ClassNotFoundException(packageName
					+ " does not appear to be "
					+ "a valid package (Null pointer exception)");
		} catch (UnsupportedEncodingException encex) {
			throw new ClassNotFoundException(packageName
					+ " does not appear to be "
					+ "a valid package (Unsupported encoding)");
		} catch (IOException ioex) {
			throw new ClassNotFoundException(
					"IOException was thrown when trying "
							+ "to get all resources for " + packageName);
		}

		// For every directory identified capture all the .class files
		for (File directory : directories) {
			classes.addAll (classes (packageName, directory));
//			if (directory.exists()) {
//				// Get the list of the files contained in the package
//				String[] files = directory.list();
//				for (String file : files) {
//					// we are only interested in .class files
//					if (file.endsWith(".class")) {
//						//System.out.println (file.toString());
//						// removes the .class extension
//						classes.add(Class.forName(packageName + '.'
//								+ file.substring(0, file.length() - 6)));
//					}
//				}
//			} else {
//				throw new ClassNotFoundException(packageName + " ("
//						+ directory.getPath()
//						+ ") does not appear to be a valid package");
//			}
		}
		return classes;
	}

	private List<Class<?>> classes (String packageName, File directory) throws ClassNotFoundException {
		ArrayList<Class<?>> classes = Lists.newArrayList();
		File[] files = directory.listFiles();
		for (File file : files) {
			// we are only interested in .class files
			if (file.getName().endsWith(".class")) {
				//System.out.println (file.toString());
				// removes the .class extension
				classes.add(Class.forName(packageName + '.'
						+ file.getName().substring(0, file.getName().length() - 6)));
			}
			if (file.isDirectory()) {
				classes.addAll (classes (packageName + "." + file.getName(), file));
			}
		}
		return classes;
	}
	
	public Boolean isAbstract (Integer modifiers) {
		return java.lang.reflect.Modifier.isAbstract(modifiers);
	}
	
	public Boolean isInterface (Integer modifiers) {
		return java.lang.reflect.Modifier.isInterface(modifiers);
	}
}