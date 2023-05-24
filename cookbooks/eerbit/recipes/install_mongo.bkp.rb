#
# Cookbook:: eerbit
# Recipe:: default
#
# Copyright:: 2023, The Authors, All Rights Reserved.

#####################
## Install Mongodb ##
#####################
# Reload the local package database
execute 'apt_update' do
  command 'apt update' 
end

#Install gpg and curl
['gnupg','curl',"libcurl4","wget","tar","openssl","liblzma5"].each do |p|
    package p do
      action :install
  end
end

# Download mongodb-server package
remote_file '/root/mongodb-linux-x86_64-debian11-6.0.6.tgz'do
  source 'https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian11-6.0.6.tgz'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Unnarchive mongodb-linux-x86_64-debian11-6.0.6.tgz
archive_file '/root/mongodb-linux-x86_64-debian11-6.0.6.tgz'do
  path '/root/mongodb-linux-x86_64-debian11-6.0.6.tgz'
  destination '/root/mongodb-linux-x86_64-debian11-6.0.6'
end

# Download mongosh-client package
remote_file '/root/mongosh-1.9.0-linux-x64.tgz' do
  source 'https://downloads.mongodb.com/compass/mongosh-1.9.0-linux-x64.tgz'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Unnarchive mongosh-1.9.0-linux-x64.tgz
archive_file '/root/mongosh-1.9.0-linux-x64.tgz'do
  path '/root/mongosh-1.9.0-linux-x64.tgz'
  destination '/root/mongosh-1.9.0-linux-x64'
end

# Copy mongo-server binaries to /usr/loca/bin
file '/usr/local/bin/mongod' do
  owner 'root'
  group 'root'
  mode '0755'
  content IO.read('/root/mongodb-linux-x86_64-debian11-6.0.6/mongodb-linux-x86_64-debian11-6.0.6/bin/mongod')
  action :create
end

# Copy mongosh binaries to /usr/loca/bin
file '/usr/local/bin/mongosh' do
  owner 'root'
  group 'root'
  mode '0755'
  content IO.read('/root/mongosh-1.9.0-linux-x64/mongosh-1.9.0-linux-x64/bin/mongosh')
  action :create
end

# Create mongo data dir
directory '/var/lib/mongo' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/var/log/mongodb' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'start_mongo' do
  command 'mongod --dbpath /var/lib/mongo --logpath /var/log/mongodb/mongod.log --fork'
  cwd     '/root'
end
