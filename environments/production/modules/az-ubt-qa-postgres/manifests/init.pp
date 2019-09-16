class az-ubt-qa-postgres {

require az-ubt-qa-essentials

  case $operatingsystemrelease {
    /14.04/: {
      $source_list_file = "trusty_pgdg.list"
      $gpg_file = "apt.postgresql.org.gpg"
      $apt_update_exec = "postgres-apt-update-trusty"
      $user_exec = "postgres-create-user-trusty"
    }

    /16.04/: {
      $source_list_file = "xenial_pgdg.list"
      $gpg_file = "apt.postgresql.org.gpg"
      $apt_update_exec = "postgres-apt-update-xenial"
      $user_exec = "postgres-create-user-xenial"
    }
  }

  file { "/etc/apt/sources.list.d/$source_list_file":
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    source   => "puppet:///modules/az-ubt-qa-postgres/repo/$source_list_file"
  }
  file { "/etc/apt/trusted.gpg.d/$gpg_file":
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    source   => "puppet:///modules/az-ubt-qa-postgres/repo/$gpg_file",
    require => File ["/etc/apt/sources.list.d/$source_list_file"]
  }
  exec { "$apt_update_exec":
    path => "/usr/bin:/bin",
    command  => 'apt-get update',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/etc/postgresql/', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
 #   refreshonly => true,
    require => File ["/etc/apt/trusted.gpg.d/$gpg_file"]
  }
  exec { "$user_exec":
    path => "/usr/bin:/bin",
    command  => 'createuser -s mutley && createdb -U postgres -O mutley company_test && createdb -U postgres -O mutley company_production && mkdir psql-puppet.lock',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/var/lib/postgresql/psql-puppet.lock', # executa somente se o diretorio nao existir
    user => 'postgres',
    cwd  => '/var/lib/postgresql',
    environment => ["HOME=/var/lib/postgresql", "PWD=/var/lib/postgresql"],
 #   refreshonly => true,
    require => File ["/etc/apt/trusted.gpg.d/$gpg_file"]
  }

  $postgresenhancers = [ 
     'postgresql-9.5', 
     'postgresql-contrib-9.5'
     ]

   package { $postgresenhancers: ensure => 'installed', require => Exec ["$apt_update_exec"]}

  service { 'postgresql':
    ensure => running, 
    enable => true, 
    require => Package [$postgresenhancers]
  }

  case $hostname {
    /az-eus-nix-prod-psql1|az-eus-nix-prod-psql3/: {
      file { '/etc/postgresql/9.5/main/pg_hba.conf':
        owner    => 'postgres',
        group    => 'postgres',
        mode     => 0640,
        source   => "puppet:///modules/az-ubt-qa-postgres/conf/pg_hba-master.conf",
        require => Package [$postgresenhancers],
        notify  => Service ['postgresql']
      }
      file { '/etc/postgresql/9.5/main/create-rep-user.sh':
        owner    => 'postgres',
        group    => 'postgres',
        mode     => 0755,
        source   => "puppet:///modules/az-ubt-qa-postgres/conf/create-rep-user.sh",
        require => File ['/etc/postgresql/9.5/main/pg_hba.conf'],
      }
      exec { 'postgres-create-replication-user':
        path => "/usr/bin:/bin",
        command  => 'sh -x /etc/postgresql/9.5/main/create-rep-user.sh && mkdir /var/lib/postgresql/psql-rep-user.lock',
        timeout  => 3600,
        logoutput   => true,
        creates   => '/var/lib/postgresql/psql-rep-user.lock', # executa somente se o diretorio nao existir
        user => 'postgres',
        cwd  => '/var/lib/postgresql',
        environment => ["HOME=/var/lib/postgresql", "PWD=/var/lib/postgresql"],
     #   refreshonly => true,
        require => File ['/etc/postgresql/9.5/main/create-rep-user.sh']
      }

      file { "/bkp":
        owner    => 'root',
        group    => 'root',
        mode     => 0777,
        ensure   => "directory"
      }

      mount { 'az-eus-stg-bkp-psql':
        name        => '/bkp',
        ensure      => 'mounted',
        atboot      => 'true',
        device      => '//diagbb4f0bac7be72406.file.core.windows.net/az-eus-stg-bkp-psql',
        fstype      => 'cifs',
        options     => 'vers=3.0,username=diagbb4f0bac7be72406,password=sMtBMzeERa5+i6Ods5jyevZmZ5vUts6V7ilrc8Eon/Bqdweqx5sKvPRkbEWiTHL/4iHq2QludkwnrcFESE+BNA==,dir_mode=0777,file_mode=0777,sec=ntlmssp',
        require     => File ['/bkp']
      }

      file { '/var/lib/postgresql/scripts':
        owner    => 'postgres',
        group    => 'postgres',
        ensure    => 'directory',
        recurse    => 'true',
        mode     => 0755,
        source   => "puppet:///modules/az-ubt-qa-postgres/scripts",
        require => Package [$postgresenhancers]
      }

      cron { 'bkp-psql':
        name        => 'Dump Diario',
        command => '/var/lib/postgresql/scripts/bkp-sql.sh > /dev/null  2>&1',
        user    => 'postgres',
        hour    => 1,
        minute  => 46,
        require => [ File ['/var/lib/postgresql/scripts'], Mount ['az-eus-stg-bkp-psql'] ]
      }
    }

    /az-eus-nix-prod-psql2/: {
      file { '/etc/postgresql/9.5/main/pg_hba.conf':
        owner    => 'postgres',
        group    => 'postgres',
        mode     => 0640,
        source   => "puppet:///modules/az-ubt-qa-postgres/conf/pg_hba-slave.conf",
        require => Package [$postgresenhancers]
#        notify  => Service ['postgresql']
      }
      file { '/var/lib/postgresql/9.5/main/recovery.conf':
        owner    => 'postgres',
        group    => 'postgres',
        mode     => 0640,
        source   => "puppet:///modules/az-ubt-qa-postgres/conf/recovery.conf",
        require => Package [$postgresenhancers],
        notify  => Service ['postgresql']
      }
    }
  }

  file { '/etc/postgresql/9.5/main/postgresql.conf':
    ensure => file,
    content => template("az-ubt-qa-postgres/postgresql.conf.erb"),
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    require => File ['/etc/postgresql/9.5/main/pg_hba.conf'],
    notify  => Service ['postgresql']
  }
}

