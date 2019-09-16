class az-ubt-qa-company-gemset {

require az-ubt-qa-ruby

   exec { 'company-gem-set':
     path => "/usr/bin:/bin:/home/mutley/.rvm/scripts/rvm",
     # command  => 'bash -c "source ~/.rvm/scripts/rvm && rvm gemset create company && rvm ruby-2.2.3@company"',
    command  => 'bash -c "source ~/.rvm/scripts/rvm && rvm gemset delete company && rvm gemset create company && rvm ruby-2.4.1@company"',
     timeout  => 3600,
     logoutput   => true,
    creates   => '/home/mutley/.rvm/gems/ruby-2.4.1@company/', # executa somente se o diretorio nao existir
     # creates   => '/home/mutley/.rvm/gems/ruby-2.2.3@company/', # executa somente se o diretorio nao existir
     user => 'mutley',
     cwd  => '/home/mutley/',
     environment => ["HOME=/home/mutley", "PWD=/home/mutley"],
#     refreshonly => true,
  }

}


