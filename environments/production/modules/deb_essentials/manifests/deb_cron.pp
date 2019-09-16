class deb_essentials::deb_cron {

  require deb_essentials::deb_deploy

  cron { 'pull_infra_azure':
    command => "su -c 'cd /export/company/infra-azure && /usr/bin/git pull> /dev/null  2>&1'",
    user    => 'root',
    minute  => '*/1'
  }

  # cron { 'pull_puppet':
  #   command => "su -c 'cd /etc/puppetlabs/code && /usr/bin/git pull> /dev/null  2>&1'",
  #   user    => 'root',
  #   minute  => '*/1'
  # }

}
