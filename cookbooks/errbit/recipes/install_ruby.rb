#
# Cookbook:: errbit
# Recipe:: install_ruby
#
# Copyright:: 2023, The Authors, All Rights Reserved.
execute 'apt_update' do
  command 'apt update' 
end

case node['platform']
when 'debian'
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

  #Update gem
  execute 'gem update' do
    command 'gem update --system'
  end

when 'ubuntu'
  ['build-essential','zlib1g-dev','libssl-dev','libreadline-dev','libyaml-dev','libxml2-dev','libxslt-dev','git','wget','tar','make'].each do |p|
      package p do
        # version 2.7
        action :install
      end
    end

  git '/usr/local/rbenv' do
    repository 'https://github.com/rbenv/rbenv.git'
    revision 'master'
    action :sync
  end

  directory '/usr/local/rbenv/plugins' do
    action :create
    recursive true
  end

  git '/usr/local/rbenv/plugins/ruby-build' do
    repository 'https://github.com/rbenv/ruby-build.git'
    revision 'master'
    action :sync
  end

  bash 'rbenv-init' do
    code <<-EOH
      echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile.d/rbenv.sh
      echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
      echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
    EOH
    not_if 'grep RBENV_ROOT /etc/profile.d/rbenv.sh'
  end

  rbenv_version = '2.7.6'

  bash 'install-ruby' do
    code <<-EOH
      export RBENV_ROOT="/usr/local/rbenv"
      export PATH="$RBENV_ROOT/bin:$PATH"
      eval "$(rbenv init -)"
      rbenv install #{rbenv_version}
      rbenv global #{rbenv_version}
    EOH
    not_if { File.exist?("/usr/local/rbenv/versions/#{rbenv_version}") }
  end

  execute 'update_gem' do
    command '/usr/local/rbenv/shims/gem update --system'
  end

  
end