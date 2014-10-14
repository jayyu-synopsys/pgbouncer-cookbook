require 'spec_helper.rb'

describe 'pgbouncer::example' do
  let (:chef_run) do
    runner = ChefSpec::Runner.new(step_into: ['pgbouncer_connection'])
    runner.converge described_recipe
  end

  it 'creates group pgbouncer' do
    expect(chef_run).to create_group 'pgbouncer'
  end

  it 'creates user pgbouncer' do
    expect(chef_run).to create_group 'pgbouncer'
  end

  it 'should install pgbouncer' do
    expect(chef_run).to install_package 'pgbouncer'
  end

  it 'should setup the pgbouncer directories' do
    [
     '/etc/pgbouncer',
     '/etc/pgbouncer/db_sockets',
     '/var/log/pgbouncer',
    ].each do |dir|
      expect(chef_run).to create_directory(dir).with(
        user: 'pgbouncer',
        group: 'pgbouncer',
        mode: 0775
      )
    end
  end

  it "pgbouncer::example should generate the correct pgbouncer configuration entries" do
    [
     '/etc/pgbouncer/userlist-database_example_com_ro.txt',
     '/etc/pgbouncer/pgbouncer-database_example_com_ro.ini',
     '/etc/init/pgbouncer-database_example_com_ro.conf',
     '/etc/logrotate.d/pgbouncer-database_example_com_ro'
    ].each do |template|
      expect(chef_run).to create_template(template).with(
        user: 'pgbouncer',
        group: 'pgbouncer',
        mode: 0644
      )

      current_template = chef_run.template(template)
    end
  end

  it "should start the service" do
    expect(chef_run).to start_service 'pgbouncer-database_example_com_ro-start'
  end
end
