# Java JRE Installation module

## Overview 

Author: Francisco Huertas Ferrer <francisco.huertas@centeropenmiddleware.com>

Center: Center for Open Middleware, Universidad Politecnica de Madrid

License: Apache 2.0

## Module description

This module installs Java-JRE in a System using Puppet. This installation does not use the package system of the OS system.

This version supports Debian OS family. To support new OS families, it creates  

## Support to new OS families

To create support other OS families, must be performed the following steps: 
* Create a new script that creates a structure of directories. The name of the script must be mkdir-'OS Family'.sh.erb. E.g.: mkdir-redhat.sh.erb. The fact used in the template is dir. (See mkdir-Debian.sh.erb for more information)
* Create a new script that checks if the version of JDK has changed and if it has changed, it extracts the the tar file. The name of the script must be 'OS Family'-checkversion.sh.erb. E.g.: redhat-checkversion.sh.erb. The facts used in the template are jre_filename, jre_package and java_home. (See Debiancheckversion-checkversion.sh.erb for more information). 

## Module information

### puppet directories: 

    Puppet_base_dir
    | - hieradata # data folder
    |   | - jre_module # It stores the yaml files. It must be configured in hiera.yaml and can be different
    | - module # Module folder
    |   | - files # It stores the files, the jre package must be in this directory
    |   | - manifest # It stores the manifest, 
    |   | - templates # It stores the templates. The scripts are in this directory


### Requisites 

* Puppet core version: >= 3.2
* OS Family supported: Debian (Ubuntu is supported too)
* Enable the Experimental parser for 3.2.X version. 
* Install and configure hiera.  Installation [guide](http://docs.puppetlabs.com/hiera/1/installing.html)

NOTE: How to enable experimental parser (*Only for 3.2.X core version*): Edit the puppet.conf file in the master node, that is in the puppet directory, and add this line ``parser=future`` in the master tag. 

    [master]
    ... 
    ...
    ...
    parser=future
    ...

### Installation: 

* Copy the module directory in the modules folder. 

### Setup

* Includes in the manifest the module definition ``include jre_installation`` or ``class { 'jre_installation' : }``
* Create and fill the data files: the hierarchy are defined in the heira.yaml in the puppet directory.
* Put the jre package in the file folder. It should be in tar format

### Variables description

It need to define the following variables: 
* **persistent_dir**: A persistent folder in the agent node
* **tmp_dir**: a temporal folder in the agent node. 
* **jre_filename**: The name of the jre with extesions
* **installation_path**: the path where the jre must be installed. E.g: ``/usr/lib``
* **installation_directory**: the folder name where the jre must be installed. E.g. ``jre``
* **java_home**: the full path of java directory ``/usr/lib/jre``

Example: 

    jre_filename           : 'jre-7u40-linux-x64.tar.gz'
    tmp_dir                : '/tmp'
    persistent_dir         : '/var/lib/puppet'
    installation_path      : &installation_path '/usr/lib'
    installation_directory : &installation_directory 'jre'
    java_home              :
     - *installation_path
     - '/'
     - *installation_directory

