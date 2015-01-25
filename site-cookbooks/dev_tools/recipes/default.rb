cmd = 'yum groupinstall -y "Development Tools"'
bash cmd do
  code cmd
end

%w(ruby-devel libxml2 libxslt git tree).each do |pkg|
  package pkg do
    action :install
  end
end

gem_package "bundler" do
  options("--no-ri --no-rdoc")
  action :install
end
