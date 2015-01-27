dir_name = node[:dir_name]

execute "bundle exec sh bin/stop_unicorn.sh" do
  cwd dir_name
  only_if { File.exists?("#{dir_name}/tmp/unicorn.pid") }
end

execute "bundle exec sh bin/start_unicorn.sh" do
  cwd dir_name
end
