# pool-az-eus-nix-prod-rails

node 'az-eus-nix-prod-rails1.azuredomain.bx.internal.cloudapp.net', 'az-eus-nix-prod-rails2.azuredomain.bx.internal.cloudapp.net', 'az-eus-nix-prod-rails3.azuredomain.bx.internal.cloudapp.net', 'az-eus-nix-prod-rails4.azuredomain.bx.internal.cloudapp.net' {

  include az-ubt-qa-users
  include az-ubt-qa-essentials
  include az-ubt-qa-hostnames
  include az-ubt-qa-collectd
  include az-ubt-qa-rvm
  include az-ubt-qa-ruby
  include az-ubt-qa-company-gemset
#  include az-ubt-qa-rails
  include az-ubt-qa-passenger
  include az-ubt-qa-company-app
  
}

