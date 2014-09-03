#
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
#
# All Rights Reserved
#

require "/opt/opscode/embedded/service/omnibus-ctl/open_source_chef12_upgrade"
require 'optparse'
require 'ostruct'

add_command "chef12-upgrade-data-transform", "Transfrom data from an open source Chef 11 server for upload to an Chef 12 server.", 2 do

   def parse(args)
    @options = OpenStruct.new

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: private-chef-ctl chef12-upgrade-data-transform [options]"

      opts.on("-d", "--chef11-data-dir [directory]", String, "Directory of open source Chef 11 server data. (Will ask interactively if not passed)") do |chef11_dir|
        @options.chef11_data_dir = chef11_dir
      end

      opts.on("-e", "--chef12-data-dir [directory]", String, "Directory to place transformed data. Defaults to a tmp dir.") do |chef12_dir|
        @options.chef12_data_dir = chef12_dir
      end

      opts.on("-o", "--org-name [name]", String, "The name of the Chef 12 organization to be created (Will ask interactively if not passed)") do |n|
        @options.org_name = n
      end

      opts.on("-f", "--full-org-name [name]", String, "The full name of the Chef 12 organization to be created (Will ask interactively if not passed)") do |n|
        @options.full_org_name = n
      end

      opts.on("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
   end


  ### Start script ###

  parse(ARGV)

  # Check if this is a valid directory and bail if it isn't
  chef11_data_dir = @options.chef11_data_dir || ask("Location of open source Chef 11 server data? ")
  key_file = "#{chef11_data_dir}/key_dump.json"

  chef11_upgrade = OpenSourceChef11Upgrade.new(@options, self)
  chef12_data_dir = chef11_upgrade.determine_chef12_data_dir
  chef11_upgrade.transform_chef11_data(chef11_data_dir, key_file, chef12_data_dir)

end
