class deb_essentials::deb_deploy {

  $basic_packages = [ 
     'git',
     'apt-transport-https',
     'openssl',
     'ntp',
     'ntpdate',
     'bash-completion',
     'netcat',
     'telnet',
     'tcpdump',
     'lsof'
     ]

  package { $basic_packages : 
    ensure => 'installed'
  }

  service { 'ntp':
    ensure => running, 
    enable => true,
    require => Package[$basic_packages]
	}

	file { '/export':
		owner    => 'root',
		group    => 'root',
		mode     => '0644',
		source   => 'puppet:///modules/deb_essentials/export',
	}

	file { '/export/company':
		owner    => 'root',
		group    => 'root',
		# recurse  => true,
		mode     => '0644',
		source   => 'puppet:///modules/deb_essentials/export/company',
		require  => File['/export']
	}

	file { '/export/scripts':
		owner    => 'root',
		group    => 'root',
		#recurse  => true,
		mode     => '0644',
		source   => 'puppet:///modules/deb_essentials/export/scripts',
		require  => File['/export']
	}

	file { '/export/scripts/deploy.sh':
		owner    => 'root',
		group    => 'root',
		mode     => '0755',
		source   => 'puppet:///modules/deb_essentials/export/scripts/deploy.sh',
		require  => File['/export/scripts']
	}

}

