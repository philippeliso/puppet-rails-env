class az-ubt-qa-ruby-dependencies {

require az-ubt-qa-essentials

  $rubydepenhancers = [ 
     'libssl-dev',
     'libyaml-dev',
     'libreadline-dev',
     'git-core',
     'bison',
     'libxml2-dev',
     'libxslt1-dev',
     'libcurl4-openssl-dev',
     'libsqlite3-dev',
     'sqlite3'
     ]

   package { $rubydepenhancers: ensure => 'installed', require => Exec['rub-dep-apt-update'] }

  exec { 'rub-dep-apt-update':
    path => "/usr/bin:/bin",
    command  => 'apt-get update',
    timeout  => 3600,
    logoutput   => true,
    #creates   => '/etc/collectd/', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/root/',
    environment => ["HOME=/root", "PWD=/root"],
    refreshonly => true
  }

}


