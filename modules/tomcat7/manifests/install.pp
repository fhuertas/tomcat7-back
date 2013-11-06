# tomcat7 module
# install.pp
# Copyright Francisco Huertas, Center for Open Middleware, Universidad Politecnica de Madrid


define tomcat7::create_dir ($path, $owner, $group) {
  $a1 = split ($path,'/')
  each($a1) |$value| {
    if $value != "" {
      
      $a2 = split($path,"$value")
      $reqdir = $a2[0]
      $dir = "${reqdir}${value}/"
      if $reqdir == '/' {
         file { "$dir": 
            ensure => directory, 
         }
      } elsif $dir == "${path}/" {
         file { "$dir": 
            ensure  => directory,
            owner   => "$owner", 
            group   => "$group", 
            require => File["$reqdir"], 
         }
      } else {
         file { "$dir": 
            ensure => directory,
            require => File["$reqdir"], 
         }
      }
    }
  }

}
define tomcat7::mkdir ($dir, $owner = "root", $group ="root") {
  $in_tmp_dir         = "${tomcat7::params::tmp_dir}"
  file { "${in_tmp_dir}/${module_name}-${title}.sh" : 
    mode     => 744, 
    owner    => root, 
    group    => root, 
    content  => template("${module_name}/mkdir-${::osfamily}.sh.erb") ,
  }
  exec { "${in_tmp_dir}/${module_name}-${title}.sh":
    cwd     => "${in_tmp_dir}",
    require => File["${in_tmp_dir}/${module_name}-${title}.sh"], 
  }
}
class tomcat7::install {
  
#  include tomcat7::params
#  notify {"--${tomcat7::params::tomcat_user}--":}
#  notify {"--${tomcat7::params::tomcat_service_name}":}
#  notify {"--${tomcat7::params::tomcat_security}":}
  $template_file      = "${tomcat7::params::template_file}"
  $in_service_name    = "${tomcat7::params::tomcat_service_name}"
  $in_service_path    = "${tomcat7::params::service_path}"
  $in_java_home       = "${tomcat7::params::java_home}"
  $in_java_opts       = "${tomcat7::params::java_opts}"
  $in_catalina_base   = "${tomcat7::params::catalina_base}"
  $in_catalina_home   = "${tomcat7::params::catalina_home}"
  $in_tomcat_security = "${tomcat7::params::tomcat_security}"
  $in_tomcat_user     = "${tomcat7::params::tomcat_user}"
  $in_tomcat_group    = "${tomcat7::params::tomcat_group}"
  $in_tomcat_package  = "${tomcat7::params::tomcat_package}"
  $in_tomcat_filename = "${tomcat7::params::tomcat_filename}"
  $in_tmp_dir         = "${tomcat7::params::tmp_dir}"
  $in_persistent_dir  = "${tomcat7::params::persistent_dir}"
  $in_tar_command     = "${tomcat7::params::tar_command}"
  $tomcat_admin_user  = "${tomcat7::params::tomcat_admin_user}"
  $tomcat_admin_pass  = "${tomcat7::params::tomcat_admin_pass}"
  $mydir              = "${in_persistent_dir}/tomcat7" 
 
  
  # Script to create the persistent directory 
  tomcat7::mkdir { 'create_persistent_dir' : 
    dir =>  "${mydir}", 
  }
  # check if tar is defined
  if ! defined(Package['tar']) {
    package { 'tar':
      ensure => installed,
    }
  }


  
  # Creating the service script
  file  { 'tomcat_service' : 
    ensure   => file,
    path     => "${in_service_path}/${in_service_name}", 
    owner    => root, 
    group    => root, 
    mode     => 755, 
    content  => template("$template_file") ,
  }

  # Create the catalina home
  tomcat7::mkdir {'catalina_home_1' : 
    dir  => "$in_catalina_home", 
    owner => "$in_tomcat_user",
    group => "$in_tomcat_group", 
  }

  file { 'bash-file':
    ensure  => file,  
    path    => "/${mydir}/deploy-tomcat.sh", 
    content => template("${module_name}/deploy-tomcat.sh.erb"),
    mode    => 775, 
    owner   => "root", 
    group   => "root",
    require => File["${in_tomcat_filename}"] 
    
  }
  file { "${in_tomcat_filename}" : 
    ensure   => file, 
    path     => "${mydir}/${in_tomcat_filename}", 
    owner    => "$in_tomcat_user",
    group    => "$in_tomcat_group",
    source   => "puppet:///modules/tomcat7/${in_tomcat_filename}",  
    require  => Tomcat7::Mkdir['create_persistent_dir'],
    notify   => Exec ["${module_name}_restarting","/${mydir}/deploy-tomcat.sh"] 
  }
  file { "tomcat_users" : 
    ensure   => file,
    path     => "${in_catalina_home}/conf/tomcat-users.xml", 
    owner    => "root", 
    group    => "root", 
    mode     => 600, 
    content  => template("${module_name}/tomcat-users.xml.erb") ,
    notify   => Exec["${module_name}_restarting"],
    require  => [File ["${in_tomcat_filename}"] ,Exec["/${mydir}/deploy-tomcat.sh"]], 
  }
  exec {"${module_name}_restarting" :
    cwd       => "${in_service_path}", 
    command   => "${in_service_path}/${in_service_name} restart",
    refreshonly => true, 
  }


  
  exec {"/${mydir}/deploy-tomcat.sh" : 
    cwd         => "${mydir}", 
    require     => File['bash-file'], 
    refreshonly => true, 
  }
}
