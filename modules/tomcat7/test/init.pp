  class {'tomcat7':  
    require => Class['jre_install']
  }
  class {'tomcat7::deploy': 
    packages => 'basex.war,sirius.war',
    require  => Class['tomcat7'],  
  }
  tomcat7::service {'main-restart' :
    action => 'start' , 
    require => Class['tomcat7'], 
  }

