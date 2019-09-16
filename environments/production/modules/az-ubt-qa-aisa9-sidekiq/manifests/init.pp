class az-ubt-qa-company-sidekiq {

require az-ubt-qa-apache
require az-ubt-qa-users
# require az-ubt-qa-rvm
# require az-ubt-qa-ruby
#require az-ubt-qa-rails
require az-ubt-qa-company-gemset
require az-ubt-qa-ruby-dependencies
require az-ubt-qa-redis

file { 'apache2-sk':
    source   => "puppet:///modules/az-ubt-qa-company-sidekiq/apache2",
    path     => "/etc/apache2",
    ensure   => 'directory',
    recurse  => true,
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    require  => Class ['az-ubt-qa-apache'],
    notify   => Service['apache2']
  }

  file { '/etc/apache2/sites-enabled/testapp-sk.conf':
    ensure => 'link',
    target => '/etc/apache2/sites-available/testapp-sk.conf',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/sites-enabled/testapp-sk-ssl.conf':
    ensure => 'link',
    target => '/etc/apache2/sites-available/testapp-sk-ssl.conf',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/rewrite.load':
    ensure => 'link',
    target => '/etc/apache2/mods-available/rewrite.load',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/socache_shmcb.load':
    ensure => 'link',
    target => '/etc/apache2/mods-available/socache_shmcb.load',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/ssl.load':
    ensure => 'link',
    target => '/etc/apache2/mods-available/ssl.load',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/ssl.conf':
    ensure => 'link',
    target => '/etc/apache2/mods-available/ssl.conf',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/passenger.load':
    ensure => 'link',
    target => '/etc/apache2/mods-available/passenger.load',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/passenger.conf':
    ensure => 'link',
    target => '/etc/apache2/mods-available/passenger.conf',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/mpm_event.load':
    ensure => 'link',
    target => '/etc/apache2/mods-available/mpm_event.load',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/status.conf':
    ensure => 'link',
    target => '/etc/apache2/mods-available/status.conf',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/status.load':
    ensure => 'link',
    target => '/etc/apache2/mods-available/status.load',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

    file { '/etc/apache2/mods-enabled/mpm_event.conf':
    ensure => 'link',
    target => '/etc/apache2/mods-available/mpm_event.conf',
    require => File ['apache2-sk'],
    notify   => Service['apache2']
  }

  package { 'cronolog':
    ensure => installed,
    require  => Class ['az-ubt-qa-apache']
  }
  
  service { 'apache2':
    ensure => running, 
    enable => true,
    require => Class['az-ubt-qa-apache']
  }
  
  file { '/opt/company-webservice-sk':
    ensure => directory,
    owner    => 'mutley',
    group    => 'mutley',
    mode     => 0644,
    recurse  => true,
    source   => "puppet:///modules/az-ubt-qa-company-sidekiq/app/company-sk",
    notify => [ Exec['exec-bundle-sk'], Service['apache2'], Service['sidekiq'], Service['sidekiq-critical'] ],
  }

  file { '/lib/systemd/system/sidekiq.service':
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    source   => "puppet:///modules/az-ubt-qa-company-sidekiq/app/sidekiq.service"
  }

  file { '/lib/systemd/system/sidekiq-critical.service':
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    source   => "puppet:///modules/az-ubt-qa-company-sidekiq/app/sidekiq-critical.service"
  }

  service { 'sidekiq':
    ensure => running, 
    enable => true,
    require => File['/lib/systemd/system/sidekiq.service']
  }

  service { 'sidekiq-critical':
    ensure => running, 
    enable => true,
    require => File['/lib/systemd/system/sidekiq-critical.service']
  }

  file { '/etc/profile.d/ruby-vars-sk.sh':
    owner    => 'root',
    group    => 'root',
    mode     => 0755,
    source   => "puppet:///modules/az-ubt-qa-company-sidekiq/app/ruby-vars-w-redis.sh",
    require  => File['/opt/company-webservice-sk'],
    notify => [ Exec['exec-bundle-sk'], Service['apache2'], Service['sidekiq'], Service['sidekiq-critical'] ],
  }

  exec { 'exec-bundle-sk':
    path => "/home/mutley/.rvm/gems/ruby-2.4.1/bin:/home/mutley/.rvm/gems/ruby-2.4.1@global/bin:/home/mutley/.rvm/rubies/ruby-2.4.1/bin:/home/mutley/bin:/home/mutley/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/mutley/.rvm/bin",
    # path => "/home/mutley/.rvm/gems/ruby-2.2.3/bin:/home/mutley/.rvm/gems/ruby-2.2.3@global/bin:/home/mutley/.rvm/rubies/ruby-2.2.3/bin:/home/mutley/bin:/home/mutley/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/mutley/.rvm/bin",
    command  => 'bash -c "bundle"',
    timeout  => 3600,
    logoutput   => true,  
    user => 'mutley',
    cwd  => '/opt/company-webservice-sk',
    environment => ["HOME=/home/mutley", "PWD=/opt/company-webservice", "GEM_HOME=/home/mutley/.rvm/gems/ruby-2.4.1", "GEM_PATH=/home/mutley/.rvm/gems/ruby-2.4.1:/home/mutley/.rvm/gems/ruby-2.4.1@global", "MY_RUBY_HOME=/home/mutley/.rvm/rubies/ruby-2.4.1", "RUBY_VERSION=ruby-2.4.1", "rvm_path=/home/mutley/.rvm", "rvm_prefix=/home/mutley"],
    # environment => ["HOME=/home/mutley", "PWD=/opt/company-webservice", "GEM_HOME=/home/mutley/.rvm/gems/ruby-2.2.3", "GEM_PATH=/home/mutley/.rvm/gems/ruby-2.2.3:/home/mutley/.rvm/gems/ruby-2.2.3@global", "MY_RUBY_HOME=/home/mutley/.rvm/rubies/ruby-2.2.3", "RUBY_VERSION=ruby-2.2.3", "rvm_path=/home/mutley/.rvm", "rvm_prefix=/home/mutley"],
    refreshonly => true
  }
}
