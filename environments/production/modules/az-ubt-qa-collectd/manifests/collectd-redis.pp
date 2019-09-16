class az-ubt-qa-collectd::collectd-redis {

 file { '/etc/collectd/collectd.conf.d/redis':
   owner    => 'root',
   group    => 'root',
   mode     => 0644,
   recurse  => true, 
   require  => Package['collectd'],
   source   => "puppet:///modules/az-ubt-qa-collectd/collectd.d/redis",
#   notify   => Service['collectd'],
	}
}

