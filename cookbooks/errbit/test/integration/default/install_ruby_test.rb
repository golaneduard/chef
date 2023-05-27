# Chef InSpec test for recipe errbit::install_ruby

# The Chef InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

describe command('ruby --version') do
  its('stdout') { should match(/ruby (\d+\.\d+\.\d+)/) }
  its('stdout') { should match(/ruby 2\.\d+\.\d+/) }
end