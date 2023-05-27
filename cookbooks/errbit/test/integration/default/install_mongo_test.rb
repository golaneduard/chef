# Chef InSpec test for recipe errbit::install_mongo

# The Chef InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

describe service('mongod') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/mongod.conf') do
  it { should exist }
  its('content') { should match(/bindIp: 127.0.0.1/) }
  its('content') { should match(/port: 27017/) }
end

describe port(27017) do
  it { should be_listening }
end