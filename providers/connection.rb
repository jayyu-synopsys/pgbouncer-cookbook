#
# Cookbook Name:: pgbouncer
# Provider:: connection
#

require 'set'

def initialize(*args)
  super
  @action = :setup
end

action :start do
  service "pgbouncer-start" do
    service_name "pgbouncer" # this is to eliminate warnings around http://tickets.opscode.com/browse/CHEF-3694
    provider Chef::Provider::Service::Systemd
    action [:enable, :start, :reload]
  end
end

action :restart do
  service "pgbouncer-restart" do
    service_name "pgbouncer" # this is to eliminate warnings around http://tickets.opscode.com/browse/CHEF-3694
    provider Chef::Provider::Service::Systemd
    action [:enable, :restart]
  end
end

action :stop do
  service "pgbouncer-stop" do
    service_name "pgbouncer" # this is to eliminate warnings around http://tickets.opscode.com/browse/CHEF-3694
    provider Chef::Provider::Service::Systemd
    action :stop
  end
end

action :setup do

  group new_resource.group do

  end

  user new_resource.user do
    gid new_resource.group
    system true
  end

  # Add pgdg ppa to use fresh pgbouncer
  run_context.include_recipe 'apt'

  apt_repository 'pgdg' do
    uri 'http://apt.postgresql.org/pub/repos/apt'
    distribution "#{node['lsb']['codename']}-pgdg"
    components ['main']
    key 'https://www.postgresql.org/media/keys/ACCC4CF8.asc'
  end

  # install the pgbouncer package
  #
  package 'pgbouncer' do
    action [:install, :upgrade]
  end

  service "pgbouncer" do
    provider Chef::Provider::Service::Systemd
    supports :enable => true, :start => true, :restart => true, :reload => true
    action :nothing
  end

  # build the userlist, pgbouncer.ini, upstart conf and logrotate.d templates
  {
    "/etc/pgbouncer/userlist.txt" => 'etc/pgbouncer/userlist.txt.erb',
    "/etc/pgbouncer/pgbouncer.ini" => 'etc/pgbouncer/pgbouncer.ini.erb',
    "/etc/init/pgbouncer.conf" => 'etc/init/pgbouncer.conf.erb',
    "/etc/logrotate.d/pgbouncer" => 'etc/logrotate.d/pgbouncer-logrotate.d.erb'
  }.each do |key, source_template|
    ## We are setting destination_file to a duplicate of key because the hash
    ## key is frozen and immutable.
    destination_file = key.dup

    # to get variables, use `grep "^attribute" resources/connection.rb |cut -d' ' -f2 | sed -e "s/:\(.*\),/\1: new_resource.\1,/"`
    template destination_file do
      cookbook 'pgbouncer'
      source source_template
      owner new_resource.user
      group new_resource.group
      mode destination_file.include?('userlist') ? 0600 : 0644
      variables({
        db_alias: new_resource.db_alias,
        db_host: new_resource.db_host,
        db_port: new_resource.db_port,
        db_name: new_resource.db_name,
        use_db_fallback: new_resource.use_db_fallback,
        userlist: new_resource.userlist,
        auth_user: new_resource.auth_user,
        admin_users: new_resource.admin_users,
        stats_users: new_resource.stats_users,
        users: new_resource.users,
        listen_addr: new_resource.listen_addr,
        listen_port: new_resource.listen_port,
        user: new_resource.user,
        group: new_resource.group,
        pool_mode: new_resource.pool_mode,
        max_client_conn: new_resource.max_client_conn,
        default_pool_size: new_resource.default_pool_size,
        min_pool_size: new_resource.min_pool_size,
        reserve_pool_size: new_resource.reserve_pool_size,
        server_idle_timeout: new_resource.server_idle_timeout,
        server_reset_query: new_resource.server_reset_query,
        connect_query: new_resource.connect_query,
        tcp_keepalive: new_resource.tcp_keepalive,
        tcp_keepidle: new_resource.tcp_keepidle,
        tcp_keepintvl: new_resource.tcp_keepintvl,
        server_check_query: new_resource.server_check_query,
        log_connections: new_resource.log_connections,
        log_disconnections: new_resource.log_disconnections,
        log_pooler_errors: new_resource.log_pooler_errors,
        server_lifetime: new_resource.server_lifetime,
        ignore_startup_parameters: new_resource.ignore_startup_parameters,
        server_check_delay: new_resource.server_check_delay,
        reserve_pool_timeout: new_resource.reserve_pool_timeout,
        soft_limit: new_resource.soft_limit,
        hard_limit: new_resource.hard_limit
      })
    end
  end

end

action :teardown do

  { "/etc/pgbouncer/userlist.txt" => 'etc/pgbouncer/userlist.txt.erb',
    "/etc/pgbouncer/pgbouncer.ini" => 'etc/pgbouncer/pgbouncer.ini.erb',
    "/etc/init/pgbouncer.conf" => 'etc/pgbouncer/pgbouncer.conf',
    "/etc/logrotate.d/pgbouncer" => 'etc/logrotate.d/pgbouncer-logrotate.d'
  }.each do |destination_file, source_template|
    file destination_file do
      action :delete
    end
  end

end
