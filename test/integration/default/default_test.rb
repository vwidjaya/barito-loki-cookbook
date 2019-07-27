# Inspec test for recipe barito-loki::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe group('barito') do
    it { should exist }
  end

  describe user('barito') do
    it { should exist }
  end
end

describe directory('/opt') do
  its('mode') { should cmp '0755' }
end

describe directory('/opt/bin') do
  its('mode') { should cmp '0755' }
end

describe directory('/var/cache/chef') do
  its('mode') { should cmp '0755' }
end

describe file('/opt/bin/barito-loki-default') do
  its('mode') { should cmp '0755' }
end

describe file('/etc/default/barito-loki-default') do
  its('mode') { should cmp '0600' }
end

describe systemd_service('barito-loki-default') do
  it { should be_installed }
  it { should be_enabled }
end
