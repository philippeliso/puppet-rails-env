class deb_essentials::deb_kubectl {

require deb_essentials::deb_deploy

package { 'kubectl':
  ensure => 'installed',
  require => [File['/etc/apt/sources.list.d/kubernetes.list'], Exec['kub-dep-apt-update']]
}

file { '/etc/apt/sources.list.d/kubernetes.list':
  owner    => 'root',
  group    => 'root',
  mode     => '0644',
  require  => Exec['kub-dep-apt-key'],
  notify   => Exec['kub-dep-apt-update'],
  content   => 'deb http://apt.kubernetes.io/ kubernetes-xenial main
',
  }

  exec { 'kub-dep-apt-update':
    path => "/usr/bin:/bin",
    command  => 'apt-get update',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/usr/bin/kubectl', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
    # refreshonly => true
  }

  exec { 'kub-dep-apt-key':
    path => "/usr/bin:/bin",
    command  => 'curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/etc/apt/sources.list.d/kubernetes.list', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
    # refreshonly => true
  }

}

