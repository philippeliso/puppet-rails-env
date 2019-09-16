class az-ubt-qa-collectd {

  file { 'collectd-collectd-5_5.gpg':
    path     => '/etc/apt/trusted.gpg.d/collectd-collectd-5_5.gpg',
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    source   => "puppet:///modules/az-ubt-qa-collectd/repo/collectd-collectd-5_5.gpg",
  }

  file { 'collectd-collectd-5_5-trusty.list':
    path     => '/etc/apt/sources.list.d/collectd-collectd-5_5-trusty.list',
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    require  => File['collectd-collectd-5_5.gpg'],
    source   => "puppet:///modules/az-ubt-qa-collectd/repo/collectd-collectd-5_5-trusty.list",
    notify   => Exec['collectd-apt-update'],
  }

  package { 'collectd':
    ensure => installed,
    require => [ File['collectd-collectd-5_5-trusty.list'], Exec['collectd-apt-update'] ],
  }
  
  service { 'collectd':
    ensure => running, 
    enable => true,
    require => Package['collectd']
}

 file { '/etc/collectd':
   owner    => 'root',
   group    => 'root',
   mode     => 0644,
   recurse  => true, 
   require  => Package['collectd'],
   source   => "puppet:///modules/az-ubt-qa-collectd/confs",
#   notify   => Service['collectd'],
}

 file { '/etc/collectd/collectd.conf.d':
   owner    => 'root',
   group    => 'root',
   mode     => 0755,
   recurse  => true, 
   require  => File['/etc/collectd'],
   source   => "puppet:///modules/az-ubt-qa-collectd/collectd.d/basic",
#   notify   => Service['collectd'],
}

  exec { 'collectd-apt-update':
    path => "/usr/bin:/bin",
    command  => 'apt-get update',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/etc/collectd/', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
  }

  case $operatingsystemrelease {
    /16.04/: {
      package { "libgcrypt11":
        provider => dpkg,
        ensure => installed,
        source   => "/opt/libgcrypt11_1.5.3-2ubuntu4.5_amd64.deb",
      }
      file { '/opt/libgcrypt11_1.5.3-2ubuntu4.5_amd64.deb':
        require  => Package['collectd'],
        source   => "puppet:///modules/az-ubt-qa-collectd/repo/libgcrypt11_1.5.3-2ubuntu4.5_amd64.deb"
      }
    }
  }



  case $hostname {

    /az-eus-nix-prod-railsjobs1/: {
      include az-ubt-qa-collectd::collectd-apache
      include az-ubt-qa-collectd::collectd-redis
      include az-ubt-qa-collectd::collectd-sidekiq
      include az-ubt-qa-collectd::collectd-memcached
        
      package { "libhiredis0.13":
        ensure => installed,
      }

      file { '/usr/lib/x86_64-linux-gnu/libhiredis.so.0.10':
        ensure => 'link',
        target => '/usr/lib/x86_64-linux-gnu/libhiredis.so.0.13',
        require => Package ['libhiredis0.13'],
      }
    }
    
    /az-eus-nix-prod-rails[1-9]*/: {
      include az-ubt-qa-collectd::collectd-apache
    }
    /az-eus-nix-prod-psql[1-9]*/: {
      include az-ubt-qa-collectd::collectd-postgresql
    }
    /az-eus-nix-prod-webcache1/: {
      include az-ubt-qa-collectd::collectd-memcached
    }
  }
}

