#
# Cookbook:: errbit
# Recipe:: install_mongo  
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
['gnupg','curl'].each do |p|
    package p do
      action :install
    end
  end

case node['platform']
when 'debian'
  apt_repository 'mongodb-org' do
    uri 'http://repo.mongodb.org/apt/debian'
    distribution 'bullseye/mongodb-org/6.0'
    components ['main']
    keyserver 'hkp://keyserver.ubuntu.com'
    key 'https://pgp.mongodb.com/server-6.0.asc'
    action :add
  end
when 'ubuntu'
  apt_repository 'mongodb-org' do
    uri 'http://repo.mongodb.org/apt/ubuntu'
    distribution 'jammy/mongodb-org/6.0'
    components ['multiverse']
    keyserver 'hkp://keyserver.ubuntu.com'
    key 'https://pgp.mongodb.com/server-6.0.asc'
    action :add
  end
end
  
#Reload the local package database
execute 'apt_update' do
  command 'apt update' 
end

#Install MongoDB:6.0
package 'mongodb-org' do
  action :install
end

systemd_unit 'mongod' do
  action :start
end

