#
# Cookbook Name:: lxc_manage
# Libraries:: handler
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#

module LXCManage
  module Helpers

    def set_mac_addr(mynode)
      # lxc.network.hwaddr = 86:D6:E3:18:2D:E0
      ruby_block "mac_addr_#{mynode}" do
        block do
          read_mac = File.readlines(node['lxc_container']['path']+"/"+mynode+"/config.dist").grep(/^lxc.network.hwaddr/)
          put_mac  = read_mac[0].split(/=/).join("").sub(/.*?\s+/, "").chomp

          # Reset MAC to the LXC generated one:
          node.set[:lxc_container][:node][:"#{mynode}"][:hwaddr] = put_mac
        end
      end
    end


    # On LXC create it makes us a default config. We want to back it up
    # because we will pull the generated MAC address out of it to use
    # in our own custom config
    def lxc_default_conf_backup(lxc_name, path)
      execute "backup-#{path}/#{name}/config" do
        command "mv #{path}/#{name}/config #{path}/#{name}/config.dist"
        not_if { ::File.exists?("#{path}/#{name}/config.dist") }
      end
    end


  end
end
