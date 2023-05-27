#TODO: configure port, host, user, pass from env vars
#TODO: test with last ruby version
#
# Cookbook:: errbit
# Recipe:: install_errbit
#
# Copyright:: 2023, The Authors, All Rights Reserved.

# Clone errbit repo
errbit_port = node['errbit']['port']
errbit_host = node['errbit']['host']
errbit_path = '/etc/errbit'


git errbit_path do
  repository 'https://github.com/errbit/errbit.git'
  revision 'main'  # or specify a specific branch, tag, or commit
  action :sync
end

case node['platform']
when 'debian'
  # Execute install errbit
  execute 'errbit_install' do
      command 'bundle install'
      cwd     errbit_path
    end

  # Execute command
  execute 'errbit_exec_rake' do
      command 'bundle exec rake errbit:bootstrap'
      cwd     errbit_path
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
        WorkingDirectory=#{errbit_path}
        ExecStart=/bin/bash -lc 'bundle exec rails server -b #{errbit_host} --port=#{errbit_port}'
        Restart=always

        [Install]
        WantedBy=multi-user.target
      EOF

      action [:create, :enable, :start]
    end

when 'ubuntu'
  # Execute install errbit
  execute 'errbit_install' do
    command '/usr/local/rbenv/shims/bundle install'
    cwd     errbit_path
  end

  # Execute command
  execute 'errbit_exec_rake' do
    command '/usr/local/rbenv/shims/bundle exec rake errbit:bootstrap'
    cwd     errbit_path
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
        WorkingDirectory=#{errbit_path}
        ExecStart=/bin/bash -lc '/usr/local/rbenv/shims/bundle exec rails server -b #{errbit_host} --port=#{errbit_port}'
        Restart=always

        [Install]
        WantedBy=multi-user.target
      EOF

      action [:create, :enable, :start]
    end
end