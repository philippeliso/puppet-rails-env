class az-ubt-qa-collectd::collectd-memcached {

 file { '/etc/collectd/collectd.conf.d/memcached':
   owner    => 'root',
   group    => 'root',
   mode     => 0644,
   recurse  => true, 
   require  => Package['collectd'],
   source   => "puppet:///modules/az-ubt-qa-collectd/collectd.d/memcached",
#   notify   => Service['collectd'],
	}
}

