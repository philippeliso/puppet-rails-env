class az-ubt-qa-collectd::collectd-sidekiq {

 file { '/etc/collectd/collectd.conf.d/sidekiq':
   owner    => 'root',
   group    => 'root',
   mode     => 0644,
   recurse  => true, 
   require  => Package['collectd'],
   source   => "puppet:///modules/az-ubt-qa-collectd/collectd.d/sidekiq",
#   notify   => Service['collectd'],
	}
}

