class az-ubt-qa-hostnames {

	file {"/etc/hosts":
		ensure => file,
		content => template("az-ubt-qa-hostnames/hosts.erb"),
	}
}
