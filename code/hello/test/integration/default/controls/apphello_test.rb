user_name = input('user_name')

# suite de tests pour la resource user
describe user user_name do 
  it { should exist }
  its('group') { should eq user_name }
  
  # shell : soit sur la property soit avec le matcher
  its('shell') { should eq '/usr/bin/bash'}
  it { should have_login_shell '/usr/bin/bash' }

  it { should have_home_directory "/home/#{user_name}" }
end

# verification supplementaire non possible sur la resource user
# concernant la creation du home_directory :  manage_home true

# values pour os : redhat, windows, debian, suze, aix, ...
home_dir_mode =  os.debian? ? '0750' : '0700' 

describe directory "/home/#{user_name}" do
    it { should exist }
    its('owner') { should eq user_name }
    its('group') { should eq user_name }
    its('mode') { should cmp home_dir_mode }
end


# suite de tests pour la resource file '/opt/hello.txt'
describe file '/opt/hello.txt' do
  it { should exist }  # assertion fournie par cette resource
  its('mode') { should cmp '0600' }
  its('owner') { should eq user_name }
  its('group') { should eq user_name }
  its('content') { should match(/hello from Chef/) }
end

# test répété pour les other users
other_users = %w(dba app looker)
other_users.each do |other_user|
  describe user other_user do 
    it { should exist }
    its('group') { should eq other_user }
    
    # shell : soit sur la property soit avec le matcher
    its('shell') { should eq '/usr/bin/bash'}
    it { should have_login_shell '/usr/bin/bash' }

    it { should have_home_directory "/home/#{other_user}" }
  end

  describe directory "/home/#{other_user}" do
    it { should exist }
    its('owner') { should eq other_user }
    its('group') { should eq other_user }
    its('mode') { should cmp home_dir_mode }
  end
end