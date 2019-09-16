# puma
export company_PORT="3000"
export company_RACK_ENV="production"
export company_WEB_CONCURRENCY=2 # check later if only heroku uses this var
export company_MAX_THREADS=5 # check later if only heroku uses this var
...

export company_LANG="en_US.UTF-8"

export company_RAILS_SERVE_STATIC_FILES="enabled"

# cache
export company_MEMCACHE_URL="127.0.0.1:11211"
export company_MEMCACHE_USER="mutley"

# Redis Local
export company_REDIS_USER="mutley"
export company_REDIS_HOST="127.0.0.1"
export company_REDIS_PORT="6379"
