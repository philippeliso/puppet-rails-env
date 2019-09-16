# pool-az-eus-nix-prod-railsjobs

node 'az-eus-nix-prod-railsjobs1.azuredomain.bx.internal.cloudapp.net' {

  include az-ubt-qa-users
  include az-ubt-qa-essentials
  include az-ubt-qa-hostnames
  include az-ubt-qa-collectd
  include az-ubt-qa-rvm
  include az-ubt-qa-ruby
  include az-ubt-qa-company-gemset
#  include az-ubt-qa-rails
  include az-ubt-qa-passenger
  include az-ubt-qa-company-sidekiq
  include az-ubt-qa-redis
  include az-ubt-qa-memcached

}

