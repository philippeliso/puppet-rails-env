class az-ubt-qa-redis {

  require az-ubt-qa-essentials

  exec { 'redis-install':
    path => "/usr/bin:/bin:/usr/local/bin/",
    command  => 'wget http://download.redis.io/releases/redis-4.0.1.tar.gz -P /tmp && tar xzf /tmp/redis-4.0.1.tar.gz -C /tmp/ && cd redis-4.0.1 && make distclean && make && make test && make install && echo -n | /tmp/redis-4.0.1/utils/install_server.sh',
    timeout  => 3600,
    logoutput   => true,
    creates   => '/etc/redis/', # executa somente se o diretorio nao existir
    user => 'root',
    cwd  => '/tmp/',
    environment => ["HOME=/root", "PWD=/tmp"],
    #     refreshonly => true,
  }

  file { '/etc/redis/6379.conf':
      owner    => 'root',
      group    => 'root',
      mode     => 0644,
      source   => "puppet:///modules/az-ubt-qa-redis/6379.conf",
      require  => Exec['redis-install']
  }
}


