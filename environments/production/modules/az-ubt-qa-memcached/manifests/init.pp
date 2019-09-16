class az-ubt-qa-memcached {

require az-ubt-qa-essentials

  package { 'memcached':
    ensure => installed
  }

  file { '/etc/memcached.conf':
    ensure => file,
    content => template("az-ubt-qa-memcached/memcached.conf.erb"),
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    require => Package ['memcached'],
    notify  => Service ['memcached']
  }

  service { 'memcached':
    ensure => running, 
    enable => true, 
    require => Package ['memcached']
  }

}


