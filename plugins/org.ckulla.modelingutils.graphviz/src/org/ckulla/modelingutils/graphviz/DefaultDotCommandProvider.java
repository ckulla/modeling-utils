package org.ckulla.modelingutils.graphviz;

import java.io.IOException;
import java.util.List;

import org.ckulla.modelingutils.graphviz.util.CommandRunner;

import com.google.common.collect.Lists;
import static com.google.common.collect.Lists.newArrayList;

public class DefaultDotCommandProvider implements IDotCommandProvider {

	@Override
	public List<String> getDotCommand (String ...options) {
		if (isMac() || isUnix()) {
			try {
				if (hasDot("/usr/bin/dot", "-V")) 
					return join (newArrayList ("/usr/bin/dot"), toList(options));
			} catch (Exception ex) {			
			}
			try {
				if (hasDot("/usr/local/bin/dot", "-V")) 
					return join (newArrayList ("/usr/local/bin/dot"), toList(options));
			} catch (Exception ex) {			
			}
		}
		if (System.getenv("GRAPHVIZ_PATH") != null && System.getenv("GRAPHVIZ_PATH").length() > 0) {
			try {
				if (hasDot(concatPaths (System.getenv("GRAPHVIZ_PATH"), "dot"))) 
					return join (newArrayList (concatPaths (System.getenv("GRAPHVIZ_PATH"), "dot")), toList (options));
			} catch (Exception ex) {
			}
			System.out.println ("Could not find dot in GRAPHVIZ_PATH=" + System.getenv("GRAPHVIZ_PATH"));
		} else { 
			System.out.println ("Could not find dot, please add an envornment variable GRAPHVIZ_PATH pointing to the directory containing the dot executable");
		}
		throw new RuntimeException ("Could not find dot executable on your system");
	}
	
	boolean hasDot (String... command) throws IOException, InterruptedException {
		return runCommand (command).matches("(?s)dot - graphviz version.*");
	}
	
	String runCommand (String ...command) throws IOException, InterruptedException {
		CommandRunner ce = new CommandRunner();
		ce.run(command, null, null);
		return ce.stderr.toString();
	}

	public  boolean isWindows() {
		String os = System.getProperty("os.name").toLowerCase();
		return (os.indexOf("win") >= 0);

	}

	public  boolean isMac() {
		String os = System.getProperty("os.name").toLowerCase();
		return (os.indexOf("mac") >= 0);
	}

	public boolean isUnix() {
		String os = System.getProperty("os.name").toLowerCase();
		return (os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0);

	}
	private List<String> toList (String ...options) {
		List<String> l = Lists.newArrayList ();
		for (String s : options)
			l.add (s);
		return l;
	}

	private List<String> join (List<String> a, List<String> b) {
		List<String> l = Lists.newArrayList ();
		for (String s : a)
			l.add (s);
		for (String s : b)
			l.add (s);
		return l;
	}
	
	String concatPaths (String s1, String s2) {
		String _s1 = s1;
		String _s2 = s2;
		if (s1.endsWith("/") || s1.endsWith("\\"))
			_s1 = s1.substring(0, s1.length()-1);
		if (s2.startsWith("/") || s2.startsWith("\\"))
			_s2 = s2.substring(1, s2.length());
		return _s1 + "/" + _s2;
	}
}
