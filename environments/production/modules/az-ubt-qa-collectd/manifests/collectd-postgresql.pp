class az-ubt-qa-collectd::collectd-postgresql {

 file { '/etc/collectd/collectd.conf.d/postgresql.conf':
   ensure => file,
   content => template("az-ubt-qa-collectd/postgresql-collectd.conf.erb"),
   owner    => 'root',
   group    => 'root',
   mode     => 0755,
   require  => Package['collectd'],
#   notify   => Service['collectd'],
	}
}

