cmd = 'yum groupinstall -y "Development Tools"'
bash cmd do
  code cmd
  not_if "yum list installed gcc"
end

%w(ruby-devel libxml2-devel libxslt-devel sqlite-devel git tree dstat tmux).each do |pkg|
  package pkg do
    action :install
  end
end

gem_package "bundler" do
  options("--no-ri --no-rdoc")
  action :install
end
