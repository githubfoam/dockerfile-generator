require 'json'
require 'net/http'
require 'pathname'
require 'rainbow'
require 'rspec/core/rake_task'
require 'uri'

VAGRANT_PROVIDERS = {
  virtualbox: {
    builder_type: 'virtualbox-iso'
  },
  vmware_desktop: {
    builder_type: 'vmware-iso'
  }
}.freeze

task default: ['vagrant:validate']

namespace :vagrant do
  desc 'Validate vagrant files'
  task :validate do
    Pathname.glob('*Vagrantfile*').sort.each do |template|
      puts Rainbow("Validating #{template}...").green
      unless system "vagrant validate --ignore-provider #{template}"
        puts Rainbow("#{template} is not a valid vagrant file").red
        raise "#{template} is not a valid vagrant file"
      end
    end
  end

end
