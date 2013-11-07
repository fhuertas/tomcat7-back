# tomcat7 module
# init.pp
# Copyright Francisco Huertas, Center for Open Middleware, Universidad Politecnica de Madrid
class tomcat7 (
  $catalina_home = "",
  $java_home = "") 
  {


  $information = hiera ('service_path') 

  include tomcat7::params 
  include tomcat7::install
#  include tomcat7::deploy

#  notify { "${tomcat7::params::tomcat_package}": }
#  notify { "-${tomcat7::params::service_path}": }
#  notify { "java_home": 
#    message => $information
#  }
#  notify { "feo": }
}


