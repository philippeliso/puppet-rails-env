class deb_apache {

package { 'apache2':
  ensure => 'installed',
}

service { 'apache2':
	enable => true, 
  ensure => 'running'
}  

file { '/etc/apache2/mods-enabled/ssl.conf':
ensure => 'link',
target => '/etc/apache2/mods-available/ssl.conf',
require => Package['apache2'],
notify => Service['apache2']
}

file { '/etc/apache2/mods-enabled/ssl.load':
ensure => 'link',
target => '/etc/apache2/mods-available/ssl.load',
require => Package['apache2'],
notify => Service['apache2']
}

file { '/etc/apache2/mods-enabled/proxy.conf':
ensure => 'link',
target => '/etc/apache2/mods-available/proxy.conf',
require => Package['apache2'],
notify => Service['apache2']
}

file { '/etc/apache2/mods-enabled/proxy.load':
ensure => 'link',
target => '/etc/apache2/mods-available/proxy.load',
require => Package['apache2'],
notify => Service['apache2']
}

file { '/etc/apache2/mods-enabled/proxy_http.load':
ensure => 'link',
target => '/etc/apache2/mods-available/proxy_http.load',
require => Package['apache2'],
notify => Service['apache2']
}

file { '/etc/apache2/mods-enabled/socache_shmcb.load':
ensure => 'link',
target => '/etc/apache2/mods-available/socache_shmcb.load',
require => Package['apache2'],
notify => Service['apache2']
}

file { '/etc/apache2/mods-enabled/rewrite.load':
ensure => 'link',
target => '/etc/apache2/mods-available/rewrite.load',
require => Package['apache2'],
notify => Service['apache2']
}

#   file { '/etc/yum.repos.d/jenkins.repo':
#     owner    => 'root',
#     group    => 'root',
#     mode     => '0644',
#     content   => '[jenkins]
# name=Jenkins
# baseurl=http://pkg.jenkins.io/redhat
# gpgcheck=0
# ',
#   }

  file { '/etc/apache2/ports.conf':
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
    source   => 'puppet:///modules/deb_apache/etc/apache2/ports.conf',
    require  => Package['apache2'],
    notify   => Service['apache2']
  }

  file { '/var/www/html/index.html':
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
    source   => 'puppet:///modules/deb_apache/var/www/html/index.html',
    require  => Package['apache2'],
    notify   => Service['apache2']
  }

  file { '/etc/apache2/sites-available/grafana.conf':
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
    source   => 'puppet:///modules/deb_apache/etc/apache2/sites-available/grafana.conf',
    require  => Package['apache2'],
    notify   => Service['apache2']
  }

  file { '/etc/apache2/sites-enabled/grafana.conf':
    ensure => 'link',
    target => '/etc/apache2/sites-available/grafana.conf',
    require => File['/etc/apache2/sites-available/grafana.conf'],
    notify => Service['apache2']
  }

  # file { '/etc/apache2/sites-available/proxy-apps.conf':
  #   owner    => 'root',
  #   group    => 'root',
  #   mode     => '0644',
  #   source   => 'puppet:///modules/deb_apache/etc/apache2/sites-available/proxy-apps.conf',
  #   require  => Package['apache2'],
  #   notify   => Service['apache2']
  # }

# file { '/etc/apache2/sites-enabled/proxy-apps.conf':
# ensure => 'link',
# target => '/etc/apache2/sites-available/proxy-apps.conf',
# require => File['/etc/apache2/sites-available/proxy-apps.conf'],
# notify => Service['apache2']
# }
}

