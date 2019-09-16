class az-ubt-qa-ruby {

require az-ubt-qa-rvm

  $rubyenhancers = [ 
     'imagemagick', 
     'libmagickwand-dev',
     'nodejs', 
     'postgresql-client'
     ]

   package { $rubyenhancers: ensure => 'installed'}

   exec { 'ruby-install':
     path => "/usr/bin:/bin:",
     # command  => 'bash -c "source ~/.rvm/scripts/rvm && rvm uninstall 2.5.1 && rvm install ruby-2.2.3 && rvm use ruby-2.2.3 --default"',
     command  => 'bash -c "source ~/.rvm/scripts/rvm && rvm uninstall 2.5.1 && rvm install ruby-2.4.1 && rvm use ruby-2.4.1 --default"',
     timeout  => 3600,
     logoutput   => true,
#     logoutput => on_failure
     # creates   => '/home/mutley/.rvm/rubies/ruby-2.2.3', # executa somente se o diretorio nao existir
    creates   => '/home/mutley/.rvm/rubies/ruby-2.4.1', # executa somente se o diretorio nao existir
     user => 'mutley',
     cwd  => '/home/mutley/',
     environment => ["HOME=/home/mutley", "PWD=/home/mutley"],
#     refreshonly => true,
  }

}


