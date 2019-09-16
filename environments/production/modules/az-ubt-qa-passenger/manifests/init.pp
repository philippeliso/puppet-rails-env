class az-ubt-qa-passenger {

#require az-ubt-qa-company-app
require az-ubt-qa-ruby-dependencies

  package { 'libapache2-mod-passenger':
    ensure => installed,
    require => Exec ['passenger-apt-update']
  }

  exec { 'passenger-apt-update':
    path => "/usr/bin:/bin",
    command  => 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7 && apt-get update',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/usr/bin/passenger_free_ruby', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
#   refreshonly => true,
    require => File ['/etc/apt/sources.list.d/passenger.list']
  }

  case $operatingsystemrelease {
    /14.04/: {
      file { '/etc/apt/sources.list.d/passenger.list':
        owner    => 'root',
        group    => 'root',
        mode     => 0600,
        source   => "puppet:///modules/az-ubt-qa-passenger/passenger-14-04.list"
      }
    }  
    /16.04/: {
      file { '/etc/apt/sources.list.d/passenger.list':
        owner    => 'root',
        group    => 'root',
        mode     => 0600,
        source   => "puppet:///modules/az-ubt-qa-passenger/passenger-16-04.list"
      } 
    }
  }

}


