#
# Cookbook Name:: lxc_manage
# Recipe:: default
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


include_recipe "lxc_manage::packages"


default_domain = "thezengarden.net"


# Steps to perform:
# -----------------
# 1. lxc-create -t <template> -n <node-name>
# 2. grep hwaddr from /var/lib/lxc/<node-name>/config
# 3. extract hwaddr into default['lxc_container']['node']['node-name']['hwaddr']
# ------------------------------------------
# 4. mv config to config.dist
# 5. write new config per container_config.erb
# 6. lxc-start -n node-name -d
# 7. (possible) lxc-create -t centos -n fuku -- --release=7


node['lxc_container']['node'].each do |name,vars|

  if vars['active']
    execute "create-lxc-#{name}" do
      command "lxc-create -t #{vars['type']} -n #{name}"
      not_if "lxc-ls | grep #{name}"
    end

    execute "backup-#{node['lxc_container']['path']}/#{name}/config" do
      command "mv #{node['lxc_container']['path']}/#{name}/config #{node['lxc_container']['path']}/#{name}/config.dist"
      not_if { ::File.exists?("#{node['lxc_container']['path']}/#{name}/config.dist") }
    end


    set_mac_addr(name)

    mac_addr = ""
    ruby_block "set_#{name}_mac_addr" do
      block do
        mac_addr = node[:lxc_container][:node][:"#{name}"][:hwaddr]
      end
    end

    template "#{node['lxc_container']['path']}/#{name}/config" do
      source "container_config.erb"

      variables ( lazy {
        {
          :rootfs  => "#{node['lxc_container']['path']}/#{name}/rootfs",
          :utsname => "#{name}.#{default_domain}",
          :hwaddr  => mac_addr
        }
      })

      only_if { ::File.exists?("#{node['lxc_container']['path']}/#{name}/config.dist") }
    end

    execute "launch-lxc-#{name}" do
      command "lxc-start -n #{name} -d"
      not_if "lxc-ls --active | grep #{name}"
    end

  else
    execute "destroy-lxc-#{name}" do
      command "lxc-stop -k -n #{name}; lxc-destroy -n #{name}"
      only_if "lxc-ls | grep #{name}"
    end
  end
end
