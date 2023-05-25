#
# Cookbook:: eerbit
# Recipe:: install_ruby
#
# Copyright:: 2023, The Authors, All Rights Reserved.
execute 'apt_update' do
  command 'apt update' 
end

['build-essential','zlib1g-dev','libssl-dev','libreadline-dev','libyaml-dev','libxml2-dev','libxslt-dev','git','wget','tar','make'].each do |p|
    package p do
      # version 2.7
      action :install
    end
  end

#Download Ruby source code
remote_file '/root/ruby-2.7.6.tar.gz' do
  source 'https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.6.tar.gz'
  action :create
end

#Unnarchide ruby-2.7.6.tar.gz
archive_file 'ruby-2.7.6.tar.gz' do
  path '/root/ruby-2.7.6.tar.gz'
  destination '/root/ruby-2.7.6'
end

#Execute configure in ruby folder
execute 'ruby_configure' do
  command './configure'
  cwd     '/root/ruby-2.7.6/ruby-2.7.6'
end

#Execute make in ruby folder
execute 'ruby_make' do
  command 'make'
  cwd     '/root/ruby-2.7.6/ruby-2.7.6'
end

#Execute make install in ruby folder
execute 'ruby_make_install' do
  command 'make install'
  cwd     '/root/ruby-2.7.6/ruby-2.7.6'
end