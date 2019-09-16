class az-ubt-qa-influxdb {

#require az-ubt-qa-essentials
require az-ubt-qa-collectd

  case $operatingsystemrelease {
    /16.04/: {
      file { '/etc/apt/sources.list.d/influxdb.list':
        owner    => 'root',
        group    => 'root',
        mode     => 0644,
        source   => "puppet:///modules/az-ubt-qa-influxdb/repo/influxdb-xenial.list"
      }
    }
    /14.04/: {
      file { '/etc/apt/sources.list.d/influxdb.list':
        owner    => 'root',
        group    => 'root',
        mode     => 0644,
        source   => "puppet:///modules/az-ubt-qa-influxdb/repo/influxdb-trusty.list"
      }
    }
  }

  file { '/etc/apt/trusted.gpg.d/influxdb.key':
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    source   => "puppet:///modules/az-ubt-qa-influxdb/repo/influxdb.key",
    require => File ['/etc/apt/sources.list.d/influxdb.list']
  }

  exec { 'influxdb-apt-update':
    path => "/usr/bin:/bin",
    command  => 'apt-key add /etc/apt/trusted.gpg.d/influxdb.key && apt-get update',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/etc/influxdb/', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
 #   refreshonly => true,
    require => File ['/etc/apt/trusted.gpg.d/influxdb.key']
  }

  package { 'influxdb': 
    ensure => 'installed', 
    require => Exec ['influxdb-apt-update']
  }

  service { 'influxdb':
    ensure => running, 
    enable => true, 
    require => Package ['influxdb']
  }

  case $hostname {

    /az-eus-nix-prod-devops1/: {
      file { '/etc/influxdb/influxdb.conf':
        source   => "puppet:///modules/az-ubt-qa-influxdb/conf/influxdb-17.conf",
        owner    => 'root',
        group    => 'root',
        mode     => 0644,
        require => Package ['influxdb'],
        notify  => Service ['influxdb']
      }
    }

    /az-eus-nix-prod-influxdb1/: {
      file { '/etc/influxdb/influxdb.conf':
        source   => "puppet:///modules/az-ubt-qa-influxdb/conf/influxdb-14.conf",
        owner    => 'root',
        group    => 'root',
        mode     => 0644,
        require => Package ['influxdb'],
        notify  => Service ['influxdb']
      }
    }
  }



}



