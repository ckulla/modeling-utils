package org.ckulla.modelingutils.testutils.rules;

import java.util.ArrayList;
import java.util.List;

public class Lists {

	public static <T> List<T> newArrayList() {
		ArrayList<T> rv = new ArrayList<T> ();
		return rv;
	}

	public static <T> List<T> newArrayList(T... ts) {
		ArrayList<T> rv = new ArrayList<T> (ts.length);
		for (T t : ts)
			rv.add (t);
		return rv;
	}
}
