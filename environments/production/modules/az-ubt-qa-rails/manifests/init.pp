class az-ubt-qa-rails {

require az-ubt-qa-company-gemset

   exec { 'rails-install':
     path => "/usr/bin:/bin",
     command  => 'bash -c "source ~/.rvm/scripts/rvm && gem install rails -v 4.2.5"',
     timeout  => 3600,
     logoutput   => true,
     creates   => '/home/mutley/.rvm/gems/ruby-2.4.1/gems/rails-4.2.5/', # executa somente se o diretorio nao existir
     user => 'mutley',
     cwd  => '/home/mutley/',
     environment => ["HOME=/home/mutley", "PWD=/home/mutley"],
#     refreshonly => true,
  }

#  file { '/etc/logrotate.d/company-webservice':
#      owner    => 'root',
#      group    => 'root',
#      mode     => 0644,
#      source   => "puppet:///modules/az-ubt-qa-rails/company-webservice"
#  }
}


