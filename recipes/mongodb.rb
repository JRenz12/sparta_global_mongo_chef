apt_update 'update' do
  action :update
end

#Mongodb-org added to source list
apt_repository "mongodb-org" do
  uri "http://repo.mongodb.org/apt/ubuntu"
  distribution "xenial/mongodb-org/3.2"
  components ["multiverse"]
  keyserver 'hkp://keyserver.ubuntu.com:80'
  key "EA312927"
end

#Install and upgrade
package "mongodb-org" do
  action :upgrade
end

template '/lib/systemd/system/mongod.service' do
  source 'mongod.service.erb'
  mode '0600'
  owner 'root'
  group 'root'
  notifies :restart, 'service[mongod]'
end

template '/etc/mongod.conf' do
  variables port: node['mongo']['port'], ip_addresses: node['mongo']['ip_addresses']
  source 'mongod.conf.erb'
  mode '0755'
  owner 'root'
  group 'root'
  notifies :restart, 'service[mongod]'
end

service 'mongod' do
  supports status: true, restart: true, reload: true
  action [ :enable, :start ]
end
