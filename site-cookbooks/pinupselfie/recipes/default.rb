package "httpd" do
  action :install
end

service "httpd" do
  action [:enable, :start]
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

execute "bundle exec ruby #{dir_name}/bin/update_photos.rb" do
  cwd dir_name
end

cmds = [
  "cp -rf #{dir_name}/public/assets #{dir_name}/public/index.html /var/www/html"
]

cmds.each do |cmd|
  bash(cmd) { code(cmd) }
end
