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
  if vars['active']
    lxc_manage_node "creating-#{name}" do
      lxc_name name
      lxc_ver  vars["lxc_version"] if vars["lxc_version"]
      lxc_vars vars
      action :create
      not_if "lxc-ls | grep #{name}"
    end
    if vars['run'] == false
      lxc_manage_node "stop-#{name}" do
        lxc_name name
        action :stop
        only_if "lxc-ls | grep #{name}"
        only_if "lxc-ls --active | grep #{name}"
      end
    else
      lxc_manage_node "start-#{name}" do
        lxc_name name
        action :start
        not_if "lxc-ls --active | grep #{name}"
        only_if "lxc-ls | grep #{name}"
      end
    end
  elsif vars['active'] == false
    lxc_manage_node "destroying-#{name}" do
      lxc_name name
      action :destroy
    end
  end
end
