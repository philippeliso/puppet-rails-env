class az-ubt-qa-essentials {

require az-ubt-qa-users
require az-ubt-qa-hostnames
require az-ubt-qa-ntp

  $ubtenhancers = [ 
     'libpq-dev', 
     'openssl', 
     'curl', 
     'build-essential',
     'wget',
     'tcl',
     'vim', 
     'bash-completion', 
     'git', 
     'lsof'
     ]

  package { $ubtenhancers: ensure => 'installed'}
  # package { $ubtenhancers: ensure => 'installed', require => Exec['ubt-enhancers-apt-update'] }

 file { 'sysadmins.sh':
    path     => '/etc/profile.d/sysadmins.sh',
    source   => "puppet:///modules/az-ubt-qa-essentials/sysadmins.sh",
    ensure => present
  }

  file { '/etc/sudoers':
    path     => '/etc/sudoers',
    owner    => 'root',
    group    => 'root',
    mode     => 0440,
    source   => "puppet:///modules/az-ubt-qa-essentials/sudoers"
  }

}
