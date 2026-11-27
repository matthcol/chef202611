user_name = input('user_name')

# suite de tests pour la resource file '/opt/hello.txt'
describe file '/opt/hello.txt' do
  it { should exist }  # assertion fournie par cette resource
  its('mode') { should cmp '0600' }
  its('owner') { should eq user_name }
  its('group') { should eq user_name }
  its('content') { should match(/hello from Chef/) }
end

describe user user_name do 
  it { should exist }
end