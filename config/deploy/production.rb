set :branch, 'master'
set :rails_env, 'production'
set :unicorn_env, 'production'

set :puma_threads, [4, 12]
set :puma_workers, 0

server '92.53.91.88', user: 'deployer', roles: %w{app web}
