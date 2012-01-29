package org.ckulla.modelingutils.cppcodegen.generator

import com.google.inject.Inject
import org.junit.Test
import org.junit.contrib.guice.GuiceRule
import org.junit.contrib.rules.Rules
import org.junit.contrib.rules.RulesTestRunner
import org.junit.runner.RunWith

import static junit.framework.Assert.*

@RunWith(typeof(RulesTestRunner))
@Rules({ typeof(GuiceRule) })
class CommentBeautifierTest {
	
	@Inject CommentBeautifier commentBeautifier
	
	def void assertMultiLineComment (CharSequence expect, CharSequence input) {
		assertEquals (expect?.toString, commentBeautifier.toMultinLineComment(input?.toString)?.toString)
	}
		
	@Test
	def void testEmpty () {
		assertMultiLineComment (null, null)
		assertMultiLineComment (null, '''''')
	}
	
	@Test
	def void testSingleWord () {
		assertMultiLineComment ('''
			/**
			 * Hello
			 */
			''', 
			'''Hello''')
	}
	
	@Test
	def void testLineSplittingByWhitespace () {
		assertMultiLineComment ('''
			/**
			 * This is a very long comment spanning multiple lines. This is a very
			 * long comment spanning multiple lines.
			 */
			''', 
			'''This is a very long comment spanning multiple lines. This is a very long comment spanning multiple lines.''')
	}

	@Test
	def void testNewLine () {
		assertMultiLineComment ('''
			/**
			 * This is a very long comment spanning multiple lines.
			 * 
			 * This is a very long comment spanning multiple lines.
			 */
			''', 
			'''
			This is a very long comment spanning multiple lines.
			This is a very long comment spanning multiple lines.''')
	}	
	
	@Test
	def void testLoreIpsum () {
		assertMultiLineComment ('''
			/**
			 * Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod
			 * tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim
			 * veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea
			 * commodi consequat. Quis aute iure reprehenderit in voluptate velit esse
			 * cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat
			 * cupiditat non proident, sunt in culpa qui officia deserunt mollit anim
			 * id est laborum.
			 * 
			 * Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse
			 * molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero
			 * eros et accumsan et iusto odio dignissim qui blandit praesent luptatum
			 * zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum
			 * dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh
			 * euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.
			 */
			''', 
			'''
			Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
			Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.''')
	}
}