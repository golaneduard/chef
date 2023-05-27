# Chef InSpec test for recipe errbit::install_errbit

# The Chef InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

control 'Errbit Service' do
  impact 0.7
  title 'Verify Errbit service'
  desc 'Ensure that Errbit service is running and listening on the correct port.'

  describe service('errbit') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe port(3333) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end
end
