package org.ckulla.xtend2utils.graphviz.util;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import org.apache.log4j.Logger;

public class CommandExecutor {

	Logger log = Logger.getLogger (CommandExecutor.class);

	public int execute(String[] cmdArray, String[] envp, File dir) {
		try {
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
