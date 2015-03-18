#
# Cookbooklxc_node['id']:: lxc_manage
# Recipe:: default
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


# Install LXC Packages:
include_recipe "lxc_manage::packages"


# Pull list of nodes from the data bag:
# lxc_nodes = search(:lxc_nodes, 'id:*')


node['lxc_container']['nodes'].each do |ln|
  lxc_node = data_bag_item("lxc_nodes", ln)

  if lxc_node['active']
    lxc_manage_node "creating-#{lxc_node['id']}" do
      lxc_name lxc_node['id']
      lxc_ver  lxc_node['version'] if lxc_node['version']
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
      lxc_manage_node "update-conf-#{lxc_node['id']}" do
        lxc_name lxc_node['id']
        lxc_ver  lxc_node['version'] if lxc_node['version']
        lxc_vars lxc_node
        action :update_conf
        only_if "lxc-ls | grep #{lxc_node['id']}"
        not_if "lxc-ls --active | grep #{lxc_node['id']}"
      end
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
