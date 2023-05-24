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
['gnupg','curl','systemctl'].each do |p|
    package p do
      action :install
    end
  end

#Import MongoDB public GPG Key
execute 'mongodb_import_gpg_key' do
  command 'curl -fsSL https://pgp.mongodb.com/server-6.0.asc | gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor'
end

# Create mongodb source-list 
execute 'mongo_source_list' do
  command 'echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list'
end

#Reload the local package database
execute 'apt_update' do
  command 'apt update' 
end

#Install MongoDB:6.0
package 'mongodb-org' do
  action :install
end
