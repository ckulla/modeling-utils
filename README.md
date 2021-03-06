Modeling Utilities
====================

This is a collection of utilities to:

* generate C++ source files with Xtend2 and EMF
* generate Java and Xtend2 code
* create graphs and visualization with graphviz

The target audience are Eclipse developers 

Modules Overview
-----------------

TODO 

Directory Structure
--------------------

* /plugins : The core plug-ins of the project
* /releng : Release Engineering stuff, drives the automated build and provides the target platform
* /tests : Test plug-ins. These plug-ins provide test for the core plug-ins.

Building
---------

The build is driven by maven and tycho. You run it by executing:

1. cd releng/org.ckulla.modelingutils.parent

2. ./build.py compile

The build script takes care of creating a local repository before executing the actual build. This
speed up subsequent builds, because tycho will run against the local repository without contacting
remote p2 sites.

Creating Releases
------------------

A release is created by executing the realese script. You pass a release version and a development
version to the release script. The release will be crearted for the release version and the 
resulting update site will be placed into releng/org.ckulla.modelingutils.releases. Then the version 
will be set to developmenet version (-SNAPSHOT postfix is added automatically). This script also 
takes care of commiting changes to the git repository. 

The option --dry-run is used to do the release cycle without commit changes. Do this to verify the
release can be created succesfully before actullay doing it.

cd releng/org.ckulla.modelingutils.parent
./release.py --dry-run 0.1.0 0.2.0
./release.py 0.1.0 0.2.0

Notes
------

* Dealing with generated sources

Generated sources are not checked in. Nevertheless the directory itself needs to be checked in. 
Otherwise Eclipse will treat non existing source directories as an error when importing the 
projects after checking out the sources. 

You create an empty directory with git by placing a .gitignore file in the directory with the
following content (all files will be ignored, despite of the .gitignore file itself)

	*
	# Except this file
	!.gitignore

* Java sources in additional directories are not compiled by tycho

Check build.properties in your plug-in. Tycho reconfigures source directories to match those in the
build.properties files. The source directories configured in maven do not matter for compiling java
sources (see https://bugs.eclipse.org/bugs/show_bug.cgi?id=342841).
