
# disable default system pgbouncer service
if node['platform'] == 'ubuntu'
    cookbook_file "/etc/default/pgbouncer" do
        backup false
        owner "root"
        group "root"
        mode 0644
    end
end
