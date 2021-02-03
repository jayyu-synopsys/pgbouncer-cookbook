
pgbouncer_connection "kb_spider" do
  db_host "localhost"
  db_port "5433"
  listen_port "5432"
  db_name "kb_spider"
  userlist "apitest" => "md5f72b9285fd6b4f628c78cb4a17488c2c", "readonly_user" => "md500000000000000000000000000000000"
  max_client_conn 100
  default_pool_size 20
  action [ :setup, :restart ]
end
