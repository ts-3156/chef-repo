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
  # user "123"
  # group "456"
  action :sync
end

gem_package "bundler" do
  options("--no-ri --no-rdoc")
  action :install
end

cmds = [
  # 'gem install bundler --no-ri --no-rdoc',
  "cd #{dir_name} && bundle install --path .bundle",
  "cd #{dir_name} && bundle exec ruby bin/update_photos.rb",
  "cp -rf #{dir_name}/public/assets #{dir_name}/public/index.html /var/www/html"
]

cmds.each do |cmd|
  bash(cmd) { code(cmd) }
end
