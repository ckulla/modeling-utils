package org.eclipse.emf.visualization.graphviz;

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
		if (isUnix() || isMac())
			return "/usr/local/bin/dot";
		else
			return System.getenv("GRAPHVIZ_PATH") + "\\dot.exe";
	}

}
