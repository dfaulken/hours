#!/usr/bin/env puma

directory '/srv/hours/current'
rackup "/srv/hours/current/config.ru"
environment 'production'

tag ''

pidfile "/srv/hours/shared/tmp/pids/puma.pid"
state_path "/srv/hours/shared/tmp/pids/puma.state"
stdout_redirect '/srv/hours/current/log/puma.error.log', '/srv/hours/current/log/puma.access.log', true


threads 0,16



bind 'unix:///srv/hours/shared/tmp/sockets/hours-puma.sock'

workers 0





preload_app!


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end


before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

