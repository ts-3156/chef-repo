package "httpd" do
  action :install
end

service "httpd" do
  action [:enable, :start]
end

git "/var/www/pinupselfie" do
  repository "https://github.com/ts-3156/pinupselfie.git"
  revision "master"
  # user "123"
  # group "456"
  action :sync
end

