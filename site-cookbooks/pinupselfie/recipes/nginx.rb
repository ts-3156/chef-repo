package "nginx" do
  action :install
end

service "nginx" do
  action [:enable, :start]
end

template '/etc/nginx/nginx.conf' do
  owner 'root'
  mode  0644
  source 'nginx.conf.erb'
end
