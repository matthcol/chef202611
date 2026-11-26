#
# Cookbook:: hello
# Recipe:: default
#
# Copyright:: 2026, The Authors, All Rights Reserved.


# utilisation de la resource file
file '/opt/hello.txt' do
  content 'hello from Chef\n'
  owner 'root'
  group 'root'
  mode '0700'
  action :create
end

