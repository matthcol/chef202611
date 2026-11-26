#
# Cookbook:: hello
# Recipe:: default
#
# Copyright:: 2026, The Authors, All Rights Reserved.


# utilisation de la resource user
user 'hello' do
  comment 'Hello user'
  shell '/usr/bin/bash'
  manage_home true
  action :create
  # action :remove
end

# utilisation de la resource file
file '/opt/hello.txt' do
  content "hello from Chef\nlet's taste this\n"
  owner 'hello'
  group 'hello'
  mode '0600'
  action :create
end

# utilisation de la resource hostname => hostname + hosts
hostname 'hello101' do
  action :set
end

package 'nginx' do
  action :install
end

