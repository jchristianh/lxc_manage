#
# Cookbook Name:: lxc_manage
# Recipe:: default
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


include_recipe "lxc_manage::packages"


node["lxc_container"]["node"].each do |name,vars|
  if vars['active'] and !vars['hwaddr']
    lxc_manage_node "manage-#{name}" do
      lxc_name name
      lxc_ver  vars["lxc_version"] if vars["lxc_version"]
      lxc_vars vars
      action :create
    end
  # We run destroy on those marked as false because we want
  # to be tidy and cleanup after ourselves.
  # Code may be added later to permit the stopping of nodes
  # without destroying them. TBD.
  elsif vars['active'] == false
    lxc_manage_node "destroying-#{name}" do
      lxc_name name
      action :destroy
    end
  end
end
