# Tomcat7 Installation module

## Overview 

Author: Francisco Huertas Ferrer <francisco.huertas@centeropenmiddleware.com>

Center: Center for Open Middleware, Universidad Politecnica de Madrid

License: Apache 2.0

Version: 0.0.1

## Module description

This module install tomcat 7 without using package system. 

This version supports Debian OS family (Including Ubuntu). 

## Support to new OS families

To create support other OS families, must be performed the following steps: 
* Create a new script that creates a structure of directories. The name of the script must be mkdir-'OS Family'.sh.erb. E.g.: mkdir-redhat.sh.erb. The fact used in the template is dir. (See mkdir-Debian.sh.erb for more information)
* Create a new template for the tomcat 7 service. The name of the script must be tomcat7-service-${osfamily}.erb. E.g.: mkdir-redhat.sh.erb. The fact used in the template is dir. (See tomcat7-service-debian.erb for more information)

## Module information

### puppet directories: 

    Puppet_base_dir
    | - hieradata # It stores the yaml files. It must be configured in hiera.yaml and can be different
    | - module # Module folder
    |   | - files # It stores the files, the tomcat package must be in this directory
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

### Usage

All the functionality need that the variables has defined correctly, this module need jre installed in the system, This [module](https://github.com/yunxao/puppet_manual_jre_install) install a JRE in a system.

#### Install tomcat7
* Copy the tomcat file in the files folder of the module. This file must be compress using tar 
* Includes in the manifest the module definition ``include tomcat7`` or ``class { 'tomcat7' : }``

#### Deploy a war file

* Put the war file in the files folder of the module
* Indicate the war to install. It can be indicated with two metods
  * In the packages parameter, the package names must be separed with comma. E.g "package1.war,package2.war"
  * In the variables provided

#### Start / Stop Service

* Includes in the manifest the module definition ``class { 'tomcat-action' : action => '[start|stop]'}``


#### Variables description

It need to define the following variables: 

array_token : '::'
* **tomcat_admin_user**: Tomcat adminstration user
* **tomcat_admin_pass**: Tomcat administration password
* **tomcat_security**: Security enable for the tomcat
* **tomcat_name**: name of the tomcat instalce
* **tomcat_service_name**: name of the tomcat service
* **tomcat_user**: System user for the tomcat
* **tomcat_group**: System group for the tomcat
* **tomcat_version**: Version of tomcat to install
* **tomcat_package**: Filename of tomcat without extensions
* **tomcat_filename**: Filename of tomcat with extensions
* **tomcat_service_action**: Tomcat service action by default. The values can be Start and Stop
* **java_home**: JRE location
* **java_opts**: Special options of Java for tomcat in the startup
* **catalina_home**: Value for CATALINA_HOME variable. The tomcat will be installed in this folder
* **catalina_base**: Value for CATALINA_BASE variable
* **catalina_webdir**: folder where the war is deployed
* **template_file**: Template service file
* **persistent_dir**: A persistent folder in the agent node
* **array_token**: auxiliary characters to delimit arrays
* **Deploy wars**: The array with the wars to deploy

Example: 

    array_token           : '::'
    tomcat_admin_user     : 'admin'
    tomcat_admin_pass     : '1234'
    tomcat_security       : 'no' # yes/no
    tomcat_name           : &name 'tomcat7'
    tomcat_service_name   : *name
    tomcat_user           : *name
    tomcat_group          : *name
    tomcat_version        : &version '7.0.42'

    tomcat_package        : &package
      - "apache-tomcat-"
      - *version

    tomcat_filename      :
      - *package
      - ".tar.gz"

    tomcat_service_action : "start" # start, stop, restart

    java_home             : '/usr/lib/jre'
    java_opts             : ''

    catalina_home         : &catalina_home
      - "/var/lib/"
      - *name

    catalina_base         :
      - "/var/lib/"
      - *name

    catalina_webdir       :
      - *catalina_home
      - "/webapps"

    template_file         : 'tomcat7/tomcat7-service.erb'
    
    deploy_wars        :
     - "basex.war"
     - "sirius.war"




