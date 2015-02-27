#
# Cookbook Name:: lxc_manage
# Recipe:: default
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


include_recipe "lxc_manage::packages"


# Steps to perform:
# -----------------
# 1. lxc-create -t <template> -n <node-name>
# 2. grep hwaddr from /var/lib/lxc/<node-name>/config
# 3. extract hwaddr into default['lxc_container']['node']['node-name']['hwaddr']
# 4. mv config to config.dist
# 5. write new config per container_config.erb
# 6. lxc-start -n node-name -d
# ------------------------------------------
# 7. (possible) lxc-create -t centos -n foo -- --release=7


node['lxc_container']['node'].each do |name,vars|
  if vars['active']
    lxc_manage_node "manage-#{name}"
      action :create
      lxc_name name
      lxc_vars vars
    end
  else
    lxc_manage_node "destroying-#{name}"
      action :destroy
      lxc_name name
    end
  end
end
