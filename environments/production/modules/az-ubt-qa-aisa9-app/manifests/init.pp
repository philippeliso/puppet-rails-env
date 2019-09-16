class az-ubt-qa-company-app {

require az-ubt-qa-apache
require az-ubt-qa-users
#require az-ubt-qa-rvm
#require az-ubt-qa-ruby
#require az-ubt-qa-rails
require az-ubt-qa-company-gemset
require az-ubt-qa-ruby-dependencies

file { 'apache2':
    source   => "puppet:///modules/az-ubt-qa-company-app/apache2",
    path     => "/etc/apache2",
    ensure   => 'directory',
    recurse  => true,
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    require  => Class ['az-ubt-qa-apache'],
    notify   => Service['apache2']
  }

  file { '/etc/apache2/sites-enabled/testapp.conf':
    ensure => 'link',
    target => '/etc/apache2/sites-available/testapp.conf',
    require => File ['apache2'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/sites-enabled/testapp-ssl.conf':
    ensure => 'link',
    target => '/etc/apache2/sites-available/testapp-ssl.conf',
    require => File ['apache2'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/rewrite.load':
    ensure => 'link',
    target => '/etc/apache2/mods-available/rewrite.load',
    require => File ['apache2'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/socache_shmcb.load':
    ensure => 'link',
    target => '/etc/apache2/mods-available/socache_shmcb.load',
    require => File ['apache2'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/ssl.load':
    ensure => 'link',
    target => '/etc/apache2/mods-available/ssl.load',
    require => File ['apache2'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/ssl.conf':
    ensure => 'link',
    target => '/etc/apache2/mods-available/ssl.conf',
    require => File ['apache2'],
    notify   => Service['apache2']
  }
  
  package { 'cronolog':
    ensure => installed,
    require  => Class ['az-ubt-qa-apache']
  }
  
  service { 'apache2':
    ensure => running, 
    enable => true,
    require  => Class ['az-ubt-qa-apache']
  }

  file { '/opt/company-webservice':
    ensure => directory,
    owner    => 'mutley',
    group    => 'mutley',
    mode     => 0644,
    recurse  => true,
    source   => "puppet:///modules/az-ubt-qa-company-app/app/company",
    notify => [ Exec['exec-bundle'], Service['apache2'] ],
  }
  file { '/etc/profile.d/ruby-vars.sh':
    owner    => 'root',
    group    => 'root',
    mode     => 0755,
    source   => "puppet:///modules/az-ubt-qa-company-app/app/ruby-vars.sh",
    require  => File['/opt/company-webservice'],
    notify => [ Exec['exec-bundle'], Service['apache2'] ],
  }
  exec { 'exec-bundle':
    path => "/home/mutley/.rvm/gems/ruby-2.4.1/bin:/home/mutley/.rvm/gems/ruby-2.4.1@global/bin:/home/mutley/.rvm/rubies/ruby-2.4.1/bin:/home/mutley/bin:/home/mutley/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/mutley/.rvm/bin",
    # path => "/home/mutley/.rvm/gems/ruby-2.2.3/bin:/home/mutley/.rvm/gems/ruby-2.2.3@global/bin:/home/mutley/.rvm/rubies/ruby-2.2.3/bin:/home/mutley/bin:/home/mutley/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/mutley/.rvm/bin",
    command  => 'bash -c "bundle"',
    timeout  => 3600,
    # logoutput   => true,  
    user => 'mutley',
    cwd  => '/opt/company-webservice',
    environment => ["HOME=/home/mutley", "PWD=/opt/company-webservice", "GEM_HOME=/home/mutley/.rvm/gems/ruby-2.4.1", "GEM_PATH=/home/mutley/.rvm/gems/ruby-2.4.1:/home/mutley/.rvm/gems/ruby-2.4.1@global", "MY_RUBY_HOME=/home/mutley/.rvm/rubies/ruby-2.4.1", "RUBY_VERSION=ruby-2.4.1", "rvm_path=/home/mutley/.rvm", "rvm_prefix=/home/mutley"],
    # environment => ["HOME=/home/mutley", "PWD=/opt/company-webservice", "GEM_HOME=/home/mutley/.rvm/gems/ruby-2.2.3", "GEM_PATH=/home/mutley/.rvm/gems/ruby-2.2.3:/home/mutley/.rvm/gems/ruby-2.2.3@global", "MY_RUBY_HOME=/home/mutley/.rvm/rubies/ruby-2.2.3", "RUBY_VERSION=ruby-2.2.3", "rvm_path=/home/mutley/.rvm", "rvm_prefix=/home/mutley"],
    refreshonly => true
  }
}
