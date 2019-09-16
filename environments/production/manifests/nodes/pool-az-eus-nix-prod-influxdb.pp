# pool-az-eus-nix-qa-influxdb

node 'az-eus-nix-qa-influxdb1.azuredomain.bx.internal.cloudapp.net', 'az-eus-nix-prod-influxdb1.azuredomain.bx.internal.cloudapp.net' {

  include az-ubt-qa-users, az-ubt-qa-essentials, az-ubt-qa-hostnames, az-ubt-qa-influxdb

}
