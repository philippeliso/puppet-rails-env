class deb_grafana_server {

# require deb_essentials

package { 'grafana':
  ensure => 'installed',
  require => [File['/etc/apt/sources.list.d/grafana.list'], Exec['grafana-dep-apt-update']],
}

service { 'grafana-server':
  enable => true, 
  ensure => 'running'
} 

file { '/etc/apt/sources.list.d/grafana.list':
  owner    => 'root',
  group    => 'root',
  mode     => '0644',
  require  => [Exec['grafana-dep-apt-key'], Exec['grafana-dep-apt-update']],
  content   => 'deb https://packages.grafana.com/oss/deb stable main
',
  }

  file { '/etc/grafana/grafana.ini':
    owner    => 'root',
    group    => 'grafana',
    mode     => '0640',
    source   => 'puppet:///modules/deb_grafana_server/grafana.ini',
    require  => Package['grafana'],
    notify   => Service['grafana-server']
  }

    file { '/etc/grafana/ssl':
    owner    => 'grafana',
    group    => 'grafana',
    recurse  => true,
    mode     => '0600',
    source   => 'puppet:///modules/deb_grafana_server/ssl',
    require  => Package["grafana"],
    notify   => Service['grafana-server']
  }

  exec { 'grafana-dep-apt-update':
    path => "/usr/bin:/bin",
    command  => 'apt-get update',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/etc/grafana', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
    # refreshonly => true
  }

  exec { 'grafana-dep-apt-key':
    path => "/usr/bin:/bin",
    command  => 'curl https://packages.grafana.com/gpg.key | sudo apt-key add -',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/etc/apt/sources.list.d/grafana.list', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
    # refreshonly => true
  }

}

