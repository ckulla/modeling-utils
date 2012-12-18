package org.ckulla.modelingutils.graphviz.util;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.apache.log4j.Logger;

public class CommandRunner {

	Logger log = Logger.getLogger (CommandRunner.class);

	public StringBuffer stdout = new StringBuffer();

	public StringBuffer stderr = new StringBuffer();

	public int run(String[] cmdArray, String[] envp, File dir) throws IOException, InterruptedException {
		if (log.isInfoEnabled()) {
			String s = "";
			for (String c : cmdArray) {
				if (s != "") {
					s = s + " ";
				}
				s = s + c;
			}
			log.info ("Executing command: " + s);
		}
		Process p = Runtime.getRuntime().exec(cmdArray, envp, dir);

		InputStream inStream = p.getInputStream();
		InputStreamHandler stdoutHandler = new InputStreamHandler(stdout, inStream);

		InputStream errStream = p.getErrorStream();
		InputStreamHandler stderrHandler = new InputStreamHandler(stderr, errStream);

		p.waitFor();
		stdoutHandler.join();
		stderrHandler.join();
		
		return p.exitValue();
	}
	
	static class InputStreamHandler extends Thread {
		/**
		 * Stream being read
		 */

		private InputStream m_stream;

		/**
		 * The StringBuffer holding the captured output
		 */

		private StringBuffer m_captureBuffer;

		/**
		 * Constructor.
		 * 
		 * @param
		 */

		InputStreamHandler(StringBuffer captureBuffer, InputStream stream) {
			m_stream = stream;
			m_captureBuffer = captureBuffer;
			start();
		}

		/**
		 * Stream the data.
		 */

		public void run() {
			try {
				int nextChar;
				while ((nextChar = m_stream.read()) != -1) {
					m_captureBuffer.append((char) nextChar);
				}
			} catch (IOException ioe) {
			}
		}
	}
}
