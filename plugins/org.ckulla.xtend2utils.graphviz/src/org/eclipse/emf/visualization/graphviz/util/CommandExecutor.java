package org.eclipse.emf.visualization.graphviz.util;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

public class CommandExecutor {

	public int execute(String[] cmdArray, String[] envp, File dir) {
		try {
			Process p = Runtime.getRuntime().exec(cmdArray, envp, dir);

			StringBuffer inBuffer = new StringBuffer();
			InputStream inStream = p.getInputStream();
			new InputStreamHandler(inBuffer, inStream);

			StringBuffer errBuffer = new StringBuffer();
			InputStream errStream = p.getErrorStream();
			new InputStreamHandler(errBuffer, errStream);

			p.waitFor();

//			if (inBuffer.length()>0)
//				org.eclipse.xtend.util.stdlib.IOExtensions.info(inBuffer);
//			if (errBuffer.length()>0)
//				org.eclipse.xtend.util.stdlib.IOExtensions.error(errBuffer);

			return p.exitValue();
		} catch (Exception err) {
			err.printStackTrace();
		}
		return 0;
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
