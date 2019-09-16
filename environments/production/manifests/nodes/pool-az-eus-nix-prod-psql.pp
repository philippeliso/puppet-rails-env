# pool-az-eus-nix-prod-psql

node 'az-eus-nix-prod-psql1.azuredomain.bx.internal.cloudapp.net', 'az-eus-nix-prod-psql2.azuredomain.bx.internal.cloudapp.net', 'az-eus-nix-prod-psql3.azuredomain.bx.internal.cloudapp.net' {

  include az-ubt-qa-users, az-ubt-qa-essentials, az-ubt-qa-hostnames, az-ubt-qa-collectd, az-ubt-qa-postgres

}
