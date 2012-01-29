package org.ckulla.modelingutils.cppcodegen.generator

class CommentBeautifier {
	
	def toMultinLineComment (String s) {
		if (s != null && s.length>0)
			'''
			/**
			«FOR line:splitLines(s)» * «line»
			«ENDFOR»
			 */
			 '''
	}
	
	def splitLines (String s) {
		val lines = newArrayList()
		var i = 0
		while (i<s.length) {
			var j = i;
			var lastSpace = -1
			var newLineIndex = -1
			while ( j  < Math::min (s.length, i+72) && newLineIndex == -1) {
				if (s.charAt(j).toString == ' ') 
					lastSpace = j
				else
					if (s.charAt(j).toString == '\n')
						newLineIndex = j
				j = j + 1
			}
			if (newLineIndex == -1) {
				if (lastSpace != -1 && j >= i+72) {
					lines.add (s.substring (i, lastSpace))
					i = lastSpace + 1				
				} else {
					lines.add (s.substring (i, j))
					i = j					
				}
			} else {		
				lines.add (s.substring (i, newLineIndex))
				lines.add ("");
				i = newLineIndex + 1
			}
		}
		lines
	}
}