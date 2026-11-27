cookbook_file '/opt/copied_file.txt' do
  source 'copied_file.txt'
  owner "#{node['hello']['user_name']}"
  group "#{node['hello']['user_name']}"
  mode '0644'
  action :create
end

template '/opt/config_db.json' do
  source 'config_db.json.erb'
  owner "#{node['hello']['user_name']}"
  group "#{node['hello']['user_name']}"
  mode '0600'
  variables(
    port: node['hello']['db_port'],
    host: node['hello']['db_host']
  )
  action :create
end

remote_file '/opt/tomcat.tgz' do
  source 'https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.29/bin/apache-tomcat-11.0.29.tar.gz'
  owner "#{node['hello']['user_name']}"
  group "#{node['hello']['user_name']}"
  mode '0644'
  action :create
end


