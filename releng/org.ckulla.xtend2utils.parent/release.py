#!/usr/bin/env python 

import os
import subprocess
import sys
import string

distributionDirectory = "../../releases"

def echo (s):
	print ("[### Release ###] " + s)
	
def call (s):
	echo (s)
	subprocess.check_call(s, shell=True)
	
if sys.argv.count >= 3:

	releaseVersion = sys.argv[1]
	devVersionRaw = sys.argv[2]
	devVersion = devVersionRaw + "-SNAPSHOT"

	echo ("Set new version to release version " + releaseVersion)
	call ("mvn org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=" + releaseVersion + " -Dlocal-build")
	call ("sed -i .bak 's/.qualifier//g' ../org.ckulla.xtend2utils.updatesite/category.xml")
	call ("./build.py clean verify")
#	print ("Run mv ../org.ckulla.xtend2utils.updatesite/target/org.ckulla.xtend2utils.releng.updatesite.zip ../org.ckulla.xtend2utils.updatesite/target/org.ckulla.xtend2utils.releng.updatesite-" + releaseVersion + ".zip")

#	print ("Run git commit -a -m '[release]	Prepare for release " + releaseVersion + "'")
#	print ("Run git tag v" + releaseVersion)
#	print ("Set new version to development version " + devVersion)
#	print ("Run mvn org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=" + devVersion)
#	print ('Run sed -i .bak "s/' + releaseVersion + '/' + devVersionRaw + '\.qualifier/g" ../org.eclipselabs.spray.repository/category.xml')
#	print ("Run ./build.py clean verify")
#	print ("Run git commit -a -m '[release] Set version to " + devVersion + "'")
	
else:
	
	printf ("Usage: release.py RELEASE_VERSION DEVELOPMENT_VERSION")
	printf ("e.g. release.py 0.2 0.3")
