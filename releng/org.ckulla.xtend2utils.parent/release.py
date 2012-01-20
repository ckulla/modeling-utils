#!/usr/bin/env python 

import os
import subprocess
import sys
import string

projectName = "org.ckulla.xtend2utils"
releaseDir = projectName + ".releases"
updatesiteDir = projectName + ".updatesite"

def echo (s):
	print ("[### Release ###] " + s)
	
def call (s):
	echo (s)
	subprocess.check_call(s, shell=True)
	
if sys.argv.count >= 3:

	releaseVersion = sys.argv[1]
	devVersion = sys.argv[2]

	# Doing the release

	echo ("Set new version to release version " + releaseVersion)
	call ("mvn org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=" + releaseVersion + " -Dlocal-build")
	call ("sed -i .bak 's/.qualifier//g' ../" + updatesiteDir + "/category.xml")
	call ("./build.py clean verify")
	call ("mv ../" + updatesiteDir + "/target/" + updatesiteDir + ".zip ../" + releaseDir + "/" + releaseDir + "-" + releaseVersion + ".zip")
#	call ("git commit -a -m '[release]	Release " + releaseVersion + "'")
#	call ("git tag v" + releaseVersion)

	# Setting the development version

	echo ("Set new version to development version " + devVersion + "-SNAPSHOT")
	call ("mvn org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=" + devVersion + "-SNAPSHOT -Dlocal-build")
	call ('sed -i .bak "s/' + releaseVersion + '/' + devVersion + '\.qualifier/g" ../' + updatesiteDir + '/category.xml')
	call ("./build.py clean verify")
#	call ("git commit -a -m '[release] Set version to " + devVersion + "-SNAPSHOT'")

	print ("Release " + releaseVersion + " successfully created")
	print ("Current development version is now " + devVersion + "-SNAPSHOT")
	
else:
	
	printf ("Usage: release.py RELEASE_VERSION DEVELOPMENT_VERSION")
	printf ("e.g. release.py 0.2 0.3-SNAPSHOT")
