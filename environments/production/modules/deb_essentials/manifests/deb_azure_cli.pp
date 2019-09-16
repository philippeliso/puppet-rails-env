class deb_essentials::deb_azure_cli {

require deb_essentials::deb_deploy

package { 'azure-cli':
  ensure => 'installed',
  require => File['/etc/apt/sources.list.d/azure-cli.list']
}

file { '/etc/apt/sources.list.d/azure-cli.list':
  owner    => 'root',
  group    => 'root',
  mode     => '0644',
  require  => Exec['az-dep-apt-key'],
  notify   => Exec['az-dep-apt-update'],
  content   => 'deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main
',
  }

  exec { 'az-dep-apt-update':
    path => "/usr/bin:/bin",
    command  => 'apt-get update',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/usr/bin/az', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
    # refreshonly => true
  }

  exec { 'az-dep-apt-key':
    path => "/usr/bin:/bin",
    command  => 'curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/etc/apt/sources.list.d/azure-cli.list', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
    # refreshonly => true
  }

}

