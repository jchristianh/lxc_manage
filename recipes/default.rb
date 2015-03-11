#
# Cookbooklxc_node['id']:: lxc_manage
# Recipe:: default
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


#include_recipe "lxc_manage::packages"

# Pull list of nodes from the data bag:
lxc_nodes = search(:lxc_nodes, 'id:*')

lxc_nodes.each do |lxc_node|
  if lxc_node['active']
    lxc_manage_node "creating-#{lxc_node['id']}" do
      lxc_name lxc_node['id']
      lxc_ver  lxc_node["lxc_version"] if lxc_node["lxc_version"]
      lxc_vars lxc_node
      action :create
      not_if "lxc-ls | grep #{lxc_node['id']}"
    end
    if lxc_node['run'] == false
      lxc_manage_node "stop-#{lxc_node['id']}" do
        lxc_name lxc_node['id']
        action :stop
        only_if "lxc-ls | grep #{lxc_node['id']}"
        only_if "lxc-ls --active | grep #{lxc_node['id']}"
      end
    else
      lxc_manage_node "start-#{lxc_node['id']}" do
        lxc_name lxc_node['id']
        action :start
        not_if "lxc-ls --active | grep #{lxc_node['id']}"
        only_if "lxc-ls | grep #{lxc_node['id']}"
      end
    end
  elsif lxc_node['active'] == false
    lxc_manage_node "destroying-#{lxc_node['id']}" do
      lxc_name lxc_node['id']
      action :destroy
    end
  end
end
