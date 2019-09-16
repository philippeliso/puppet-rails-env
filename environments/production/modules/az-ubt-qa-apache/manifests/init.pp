class az-ubt-qa-apache {

  package { 'apache2':
    ensure => installed,
    require => Exec['apache2-apt-update']
  }

  exec { 'apache2-apt-update':
    path => "/usr/bin:/bin",
    command  => 'apt-get update',
    timeout  => 3600,
    logoutput   => true,
    #creates   => '/etc/collectd/', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
    refreshonly => true
  }
 
}
