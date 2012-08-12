package org.ckulla.modelingutils.graphviz;

import java.io.IOException;
import org.ckulla.modelingutils.graphviz.util.CommandExecutor;

public class DefaultDotCommandProvider implements IDotCommandProvider {

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
	
	@Override
	public String getDotCommand () {
		if (isMac() || isUnix()) {
			try {
				if (hasDot("/usr/local/bin/dot")) 
					return "/usr/local/bin/dot";
			} catch (Exception ex) {			
			}
		}
		if (System.getenv("GRAPHVIZ_PATH") != null && System.getenv("GRAPHVIZ_PATH").length() > 0) {
			try {
				if (hasDot(concatPaths (System.getenv("GRAPHVIZ_PATH"), "dot"))) 
					return concatPaths (System.getenv("GRAPHVIZ_PATH"), "dot");
			} catch (Exception ex) {
			}
			System.out.println ("Could not find dot in GRAPHVIZ_PATH=" + System.getenv("GRAPHVIZ_PATH"));
		} else { 
			System.out.println ("Could not find dot, please add an envornment variable GRAPHVIZ_PATH pointing to the directory containing the dot executable");
		}
		throw new RuntimeException ("Could not find dot executable on your system");
	}
	
	boolean hasDot (String command) throws IOException, InterruptedException {
		return runCommand (command, "-V").matches("(?s)dot - graphviz version.*");
	}
	
	String runCommand (String ...command) throws IOException, InterruptedException {
		CommandExecutor ce = new CommandExecutor();
		ce.execute(command, null, null);
		return ce.stderr.toString();
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
