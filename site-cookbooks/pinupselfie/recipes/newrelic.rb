execute "install newrelic" do
  command <<-EOH
    rpm -Uvh http://download.newrelic.com/pub/newrelic/el5/i386/newrelic-repo-5-3.noarch.rpm
    yum install -y newrelic-sysmond
    nrsysmond-config --set license_key=a716d70ec301f2b516b27ab57a563a487ca0dcb2
  EOH
end

execute "run newrelic" do
  command <<-EOH
    /etc/init.d/newrelic-sysmond start
  EOH
end

