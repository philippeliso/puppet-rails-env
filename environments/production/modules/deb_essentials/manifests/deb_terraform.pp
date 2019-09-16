class deb_essentials::deb_terraform {

	file { '/usr/bin/terraform':
		owner    => 'root',
		group    => 'root',
		mode     => '0755',
		source   => 'puppet:///modules/deb_essentials/terraform/terraform',
	}

}

