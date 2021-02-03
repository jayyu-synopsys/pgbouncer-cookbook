
pgbouncer_connection "database_example_com_ro" do
  db_host "database.example.com"
  db_port "6432"
  db_name "test_database"
  userlist "readwrite_user" => "md500000000000000000000000000000000", "readonly_user" => "md500000000000000000000000000000000"
  max_client_conn 100
  default_pool_size 20
  action [ :setup, :start ]
end
