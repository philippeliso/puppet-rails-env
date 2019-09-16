class az-ubt-qa-site-test {

require az-ubt-qa-passenger

  file { '/etc/apache2/sites-enabled/sites-test.conf':
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    source   => "puppet:///modules/az-ubt-qa-site-test/sites-test.conf"
  }

}


