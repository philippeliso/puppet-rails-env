#
class az-ubt-qa-users {

  user {'mutley':
    ensure  => 'present',
    shell   => '/bin/bash',
    uid     => '6201',
    groups  => ['sudo', 'adm'],
    home    => '/home/mutley',
    managehome  => true,
    password    => '$6$vX0e7Rf3$zBIJRsJXOJl4layNxgUegdAbG8TZgIovAwNYnbhcnhJBNSDksM0z/wGxuNQo66vGGjVawK0GSXYzd2Ea0PPmr.',
    password_max_age => '99999',
    password_min_age => '0'
  }

  file { '/home/mutley/.ssh':
    source   => "puppet:///modules/az-ubt-qa-users/.ssh",
    ensure   => 'directory',
    recurse  => true,
    owner    => 'mutley',
    group    => 'mutley',
    mode     => 0600,
    require  => User['mutley']
  }

  # Jenkins
  user {'jenkins':
    ensure  => 'present',
    shell   => '/bin/bash',
    uid     => '6202',
    groups  => ['sudo', 'adm'],
    home    => '/home/jenkins',
    managehome  => true,
    password    => '$6$vX0e7Rf3$zBIJRsJXOJl4layNxgUegdAbG8TZgIovAwNYnbhcnhJBNSDksM0z/wGxuNQo66vGGjVawK0GSXYzd2Ea0PPmr.',
    password_max_age => '99999',
    password_min_age => '0'
  }

  file { '/home/jenkins/.ssh':
    source   => "puppet:///modules/az-ubt-qa-users/jenkins/.ssh",
    ensure   => 'directory',
    recurse  => true,
    owner    => 'jenkins',
    group    => 'jenkins',
    mode     => 0600,
    require  => User['jenkins']
  }

  file { '/etc/sudoers.d/80-jenkins-sudo':
    owner    => 'root',
    group    => 'root',
    mode     => 0440,
    source   => "puppet:///modules/az-ubt-qa-users/sudoers.d/80-jenkins-sudo",
    require  => User['jenkins']
  }

}


