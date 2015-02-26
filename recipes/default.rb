#
# Cookbook Name:: lxc_manage
# Recipe:: default
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


# Steps to perform:
# -----------------
# 1. lxc-create -t <template> -n <node-name>
# ------------------------------------------
# 2. grep hwaddr from /var/lib/lxc/<node-name>/config
# 3. extract hwaddr into default['lxc_container']['node']['node-name']['hwaddr']
# 4. mv config to config.dist
# 5. write new config per container_config.erb
# 6. lxc-start -n node-name -d


node['lxc_container']['node'].each do |name,vars|
  if vars['active']
    execute "create-lxc-#{name}" do
      command "lxc-create -t #{vars['type']} -n #{name}"
      not_if "lxc-ls | grep #{name}"
    end

#    bob = File.readlines("vdm_client.rb").grep(/hostname/)

  else
    execute "destroy-lxc-#{name}" do
      command "lxc-destroy -n #{name}"
      only_if "lxc-ls | grep #{name}"
    end
  end
end
