# actions conditionnelles

if platform_family?('debian')
    apt_update 
    # properties et action par défaut
    # equivalent à : apt update
end

if platform_family?('rhel')
    package 'epel-release' # properties et action par défaut
end
  

package 'nginx' do
  action :install
end


service 'nginx' do
  action [:start, :enable]
end
