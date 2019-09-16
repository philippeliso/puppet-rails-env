# pool-az-eus-nix-prod-devops

node 'az-eus-nix-prod-devops1.azuredomain.bx.internal.cloudapp.net' {

  include deb_grafana_server, deb_apache, deb_docker_ce, az-ubt-qa-influxdb

}
