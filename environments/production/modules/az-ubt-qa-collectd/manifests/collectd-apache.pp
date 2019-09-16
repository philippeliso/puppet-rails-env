class az-ubt-qa-collectd::collectd-apache {

 file { '/etc/collectd/collectd.conf.d/apache':
   owner    => 'root',
   group    => 'root',
   mode     => 0644,
   recurse  => true, 
   require  => Package['collectd'],
   source   => "puppet:///modules/az-ubt-qa-collectd/collectd.d/apache",
#   notify   => Service['collectd'],
	}
}

