package 'nginx' do
  action :install
end


service 'nginx' do
  action [:start, :enable]
end
