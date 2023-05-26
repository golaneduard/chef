#
# Cookbook:: eerbit
# Recipe:: install_errbit
#
# Copyright:: 2023, The Authors, All Rights Reserved.

# Clone errbit repo
git 'name' do
 destination '/root'
 repository 'https://github.com/errbit/errbit.git'
 action :sync
end

# Execute install errbit
execute 'errbit_install' do
    command 'bundle install'
    cwd     '/root/errbit'
  end

# Execute command
execute 'errbit_exec_rake' do
    command 'bundle exec rake errbit:bootstrap'
    cwd     '/root/errbit'
  end

# Create systemctl service for errbit
systemd_unit 'rails-server.service' do
    content <<~EOF
      [Unit]
      Description=Rails Server
      Wants=network.target
      After=network.target
  
      [Service]
      User=root
      Group=root
      WorkingDirectory=/root/errbit
      ExecStart=/bin/bash -lc 'bundle exec rails server'
      Restart=always
  
      [Install]
      WantedBy=multi-user.target
    EOF
  
    action [:create, :enable, :start]
  end

