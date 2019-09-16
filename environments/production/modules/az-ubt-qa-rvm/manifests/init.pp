class az-ubt-qa-rvm {

require az-ubt-qa-essentials

  file { '/home/mutley/.gnupg':
    source   => "puppet:///modules/az-ubt-qa-rvm/repo/.gnupg",
#    path     => '/home/mutley/.gnupg',
    ensure   => 'directory',
    recurse  => true,
    owner    => 'mutley',
    group    => 'mutley',
    mode     => 0600
  }

   exec { 'rvm-install':
     path => "/usr/bin:/bin",
     command  => 'curl -sSL https://get.rvm.io | bash -s stable --ruby && bash -c "source ~/.rvm/scripts/rvm"',
     returns  => [0, 1, 14],
     timeout  => 3600,
     logoutput   => true,
     creates   => '/home/mutley/.rvm/scripts/rvm', # executa somente se o diretorio nao existir
     user => 'mutley',
     cwd  => '/home/mutley/',
     environment => ["HOME=/home/mutley", "PWD=/home/mutley"],
#     refreshonly => true,
     require => File['/home/mutley/.gnupg']
  }

}


