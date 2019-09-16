class deb_docker_ce {

  #require deb_essentials

  file { '/export/scripts/get-docker.sh':
    owner    => 'root',
    group    => 'root',
    recurse  => true,
    mode     => '0755',
    source   => 'puppet:///modules/deb_docker_ce/get-docker.sh'
  }

   exec { 'install_docker':
     path => "/usr/bin:/bin:",
     command  => 'sh /export/scripts/get-docker.sh',
     timeout  => 3600,
     logoutput   => true,
#     logoutput => on_failure
     creates   => '/var/lib/docker', # executa somente se o diretorio nao existir
     user => 'root',
     cwd  => '/root/',
     environment => ["HOME=/root", "PWD=/tmp"],
#     refreshonly => true,
  }
}

