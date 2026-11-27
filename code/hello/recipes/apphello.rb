# variable interne à la recette, non substituable depuis Chef
custom_line = 'tarte aux fraises'

# utilisation de la resource user
user "#{node['hello']['user_name']}" do
  comment 'Hello user'
  shell '/usr/bin/bash'
  manage_home true
  action :create
  # action :remove
end

# utilisation de la resource file
file '/opt/hello.txt' do
  content "hello from Chef\nlet's taste this\n#{custom_line}\n"
  owner "#{node['hello']['user_name']}"
  group "#{node['hello']['user_name']}"
  mode '0600'
  action :create
end

# utilisation de la resource hostname => hostname + hosts
hostname 'hello101' do
  action :set
end


# autres users : ici ou en attributes
# other_users = ['dba', 'app', 'looker']
other_users = %w(dba app looker)  # raccourci rubis pour les tableaux de string

other_users.each do |other_user|
  # resource répétée
  user "creation user #{other_user}" do
    username other_user
    shell '/usr/bin/bash'
    manage_home true
    action :create
  end
end

