# tomcat7 module
# params.pp
# Copyright Francisco Huertas, Center for Open Middleware, Universidad Politecnica de Madrid
class tomcat7::params {
#  $service_path = hiera('service_path')
#  $tomcat_service_name = hiera('tomcat_service_name')
#  $tomcat_package = hiera('tomcat_package')
#  $information = hiera('tmp')
#  $JAVA_HOME = "" 
#  $CATALINA_HOME = "" 
  $template_file         = hiera('template_file')
  $java_home             = hiera('java_home')
  $java_opts             = hiera('java_opts')
  $catalina_base         = hiera('catalina_base')
  $catalina_home         = hiera('catalina_home')
  $catalina_webdir       = hiera('catalina_webdir')
  $tomcat_security       = hiera('tomcat_security')
  $tomcat_user           = hiera('tomcat_user')
  $tomcat_group          = hiera('tomcat_group')
  $tomcat_service_name   = hiera('tomcat_service_name')
  $tomcat_package        = hiera('tomcat_package')
  $tomcat_filename       = hiera('tomcat_filename')
  $service_path          = hiera('service_path')
  $tmp_dir               = hiera('tmp_dir')
  $persistent_dir        = hiera('persistent_dir')
  $tar_command           = hiera('tar_command')
  $tomcat_service_action = hiera('tomcat_service_action')
  $array_token           = hiera('array_token')
  $tomcat_admin_user     = hiera('tomcat_admin_user')
  $tomcat_admin_pass     = hiera('tomcat_admin_pass')


  # Arrays: 
  $deploy_wars           = hiera_array('deploy_wars').join("$array_token")
#  notify{$service_path : }
}
