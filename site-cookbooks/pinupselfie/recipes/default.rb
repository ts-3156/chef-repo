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

dir_name = '/var/www/pinupselfie'

git dir_name do
  repository "https://github.com/ts-3156/pinupselfie.git"
  revision "master"
  user "root"
  group "root"
  action :sync
end

execute "bundle install --path #{dir_name}/.bundle" do
#execute "bundle install" do
  cwd dir_name
  not_if "cd #{dir_name} && bundle check"
end

# execute "bundle exec ruby #{dir_name}/bin/update_photos.rb" do
#   cwd dir_name
# end

# cmds = [
#   "cp -rf #{dir_name}/public/assets #{dir_name}/public/index.html /var/www/html"
# ]
#
# cmds.each do |cmd|
#   bash(cmd) { code(cmd) }
# end

execute "bundle exec sh bin/stop_unicorn.sh" do
  cwd dir_name
  only_if { File.exists?("#{dir_name}/tmp/unicorn.pid") }
end

execute "bundle exec sh bin/start_unicorn.sh" do
  cwd dir_name
end
