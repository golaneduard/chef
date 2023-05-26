#TODO: configure port, host, user, pass from env vars
#TODO: test with last ruby version
#
# Cookbook:: errbit
# Recipe:: install_errbit
#
# Copyright:: 2023, The Authors, All Rights Reserved.

# Clone errbit repo
git '/root/errbit' do
  repository 'https://github.com/errbit/errbit.git'
  revision 'main'  # or specify a specific branch, tag, or commit
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
systemd_unit 'errbit.service' do
    content <<~EOF
      [Unit]
      Description=Errbit Server
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

