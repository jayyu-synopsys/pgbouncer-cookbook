PGBouncer Cookbook [![Build Status](https://travis-ci.org/whitepages-cookbooks/pgbouncer.png?branch=master)](https://travis-ci.org/whitepages-cookbooks/pgbouncer)
==================

This cookbook provides a [Chef LWRP](http://docs.opscode.com/lwrp.html) that sets up 
a basic [PGBouncer](http://wiki.postgresql.org/wiki/PgBouncer) connection pool that 
fronts a Postgresql database.  It has example configuration for integration on client machines,
exposing a local *nix socket that routes to a downstream database on another host.

Requirements
============

Chef 1.4+

Platform
--------
Tested:
* Ubuntu

Untested:
* Debian (should work)
* RHEL, Centos, etc

Dependencies
---------

'apt' cookbook

Resources/Providers
===================

This cookbook exposes a single resource/provider pair, referred as `pgbouncer_connection`.  A basic 
example of its use can be found in `recipes/example.rb`, and is outlined below.

`pgbouncer_connection`
----------------------

Sets up an Upstart service for pgbouncer against a single database alias, then starts the service.
Multiple aliases may be supported on a single host.

### Actions
- :setup: configure a pgbouncer service for the specified database alias (default action)
- :start: start the configured pgbouncer service
- :stop: stop the configured pgbouncer service
- :teardown: delete the configuration (FIXME: may not be comprehensive)

### Examples
    # setup and start a read-only connection pool
    pgbouncer_connection "database_example_com_ro" do
      db_host "database.example.com"
      db_port "6432"
      db_name "test_database"
      userlist "readonly_user" => "md500000000000000000000000000000000"
      max_client_conn 100
      default_pool_size 20
      action [:setup, :start]
    end

    # setup and start a read-write connection pool
    pgbouncer_connection "database_example_com_rw" do
      db_host "database.example.com"
      db_port "6432"
      db_name "test_database"
      userlist "readwrite_user" => "md500000000000000000000000000000000", "readonly_user" => "md500000000000000000000000000000000"
      max_client_conn 100
      default_pool_size 20
      action [:setup, :start]
    end

    # setup and start a connection pool with database fallback (all databases)
    pgbouncer_connection "database_example_com_fallback" do
      db_host "database.example.com"
      db_port "6432"
      use_db_fallback true
      userlist "readwrite_user" => "md500000000000000000000000000000000", "readonly_user" => "md500000000000000000000000000000000"
      max_client_conn 100
      default_pool_size 20
      action [:setup, :start]
    end

    # stop a connection pool
    pgbouncer_connection "database_example_com_ro" do
      action :stop
    end


Recipes
=======

default
-------


