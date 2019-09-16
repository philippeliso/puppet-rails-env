class az-ubt-qa-ntp {

  package { 'ntp':
    ensure      => installed,
    provider    => apt
  }
  
  file { '/etc/ntp.conf':
    source  => 'puppet:///modules/az-ubt-qa-ntp/ntp.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['ntp'],
    notify   => [ Service['ntp'], Service['syslog'] ];
  }

  service { 'ntp':
    ensure      => running,
    enable      => true,
    require     => File['/etc/ntp.conf'];
  }

  service { 'syslog':
    ensure      => running,
    enable      => true,
    require     => File['/etc/ntp.conf'];
  }

  exec { 'set-time':
    command     => '/usr/bin/timedatectl set-timezone America/Sao_Paulo && /usr/bin/timedatectl set-ntp true',
    logoutput   => true,
    refreshonly => true,
    subscribe   => Service['ntp'];
  }

}




