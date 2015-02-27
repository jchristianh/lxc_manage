#
# Cookbook Name:: lxc_manage
# Libraries:: handler
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


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
