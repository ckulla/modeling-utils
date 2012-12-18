#!/usr/bin/env python 

import os
import subprocess
import sys
import string

def fileIsNewerThan(file, dependentFile):
	return (not os.path.exists (dependentFile)) or os.path.getmtime(file)>os.path.getmtime(dependentFile)

def createLocalRepositoryIfNotUpToDate ():
	if (fileIsNewerThan ('../../releng/org.ckulla.modelingutils.repository/category.xml', 
	                    '../../releng/org.ckulla.modelingutils.repository/target/category.xml') or
	   fileIsNewerThan ('../../releng/org.ckulla.modelingutils.targetplatform/modelingutils.target', 
					    '../../releng/org.ckulla.modelingutils.repository/target/category.xml')): 
		print 'Rebuild of repository required'
		subprocess.call ("cd ../../releng/org.ckulla.modelingutils.repository.parent && mvn package", shell=True)
	else:
		print 'Repository is up to date'

def runMaven():
	s = 'mvn ' + string.join (sys.argv[1:], ' ')
	print "Calling " + '"' + s + '"'
	return subprocess.call (s, shell=True)
	
createLocalRepositoryIfNotUpToDate()
exit (runMaven())