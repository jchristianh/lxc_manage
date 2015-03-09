#
# Cookbook Name:: lxc_manage
# Providers:: manage_node
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


action :create do

  # Some vars to increase code readability
  def_domain   = node["lxc_container"]["def_domain"]
  lxc_base     = node["lxc_container"]["path"] + "/" + new_resource.lxc_name
  lxc_type     = new_resource.lxc_vars['type'] || "centos"
  lxc_run      = new_resource.lxc_vars['run']
  rootfs       = lxc_base + "/rootfs"
  lxc_conf     = lxc_base + "/config"
  lxc_opts     = ""


  if (new_resource.lxc_ver)
    lxc_opts = "-- --release=#{new_resource.lxc_ver}"
  end


  execute "create-lxc-#{new_resource.lxc_name}" do
    command "lxc-create -t #{lxc_type} -n #{new_resource.lxc_name} #{lxc_opts}"
    not_if "lxc-ls | grep #{new_resource.lxc_name}"
  end


  # Create a backup of the LXC generated config:
  execute "backup-#{lxc_conf}" do
    command "mv #{lxc_conf} #{lxc_conf}.dist"
    not_if { ::File.exists?("#{lxc_conf}.dist") }
  end


  # We use OpenSSL to generate a random MAC address for each node.
  # LXC seems to prefix its generated addresses with 'fe', so
  # that's what we're going to adhere to.
  ruby_block "mac_addr_#{new_resource.name}" do
    block do
      def generate_mac
        mac = `openssl rand -hex 6`.chomp
        mac = mac.scan(/.{1,2}/).join(":")

        if (mac =~ /^fe:/)
          return mac
        else
          generate_mac
        end
      end

      gen_mac = generate_mac

      # Set MAC to the LXC generated one:
      node.set["lxc_container"]["node"]["#{new_resource.lxc_name}"]["hwaddr"] = gen_mac
      node.save
    end
  end


  # The MAC address node attribute got re-set to a new value above
  # we need to a re-read of that new value inside a ruby_block so
  # that we can get the updated value to write out to our template
  mac_addr = ""
  ruby_block "set_#{new_resource.lxc_name}_mac_addr" do
    block do
      mac_addr = node["lxc_container"]["node"]["#{new_resource.lxc_name}"]["hwaddr"]
    end
  end


  template "#{lxc_conf}" do
    source "container_config.erb"

    variables ( lazy {
      {
        :rootfs      => rootfs,
        :utsname     => new_resource.lxc_name + "." + def_domain,
        :hwaddr      => mac_addr,
        :autostart   => node['lxc_container']['node']['cnode6']['autostart'],
        :start_delay => node['lxc_container']['node']['cnode6']['startdelay'],
        :start_order => node['lxc_container']['node']['cnode6']['startorder'],
        :group       => node['lxc_container']['node']['cnode6']['group'],
        :ipaddr      => node['lxc_container']['node']['cnode6']['ipaddr'],
        :ipcidr      => node['lxc_container']['node']['cnode6']['ipcidr'],
        :ipgateway   => node['lxc_container']['node']['cnode6']['ipgateway']
      }
    })

    only_if { ::File.exists?("#{lxc_conf}.dist") }
  end


  execute "launch-lxc-#{new_resource.lxc_name}" do
    command "lxc-start -n #{new_resource.lxc_name} -d"
    not_if "lxc-ls --active | grep #{new_resource.lxc_name}"
    only_if { lxc_run == true }
  end
end


action :stop do
  execute "stopping-lxc-#{new_resource.name}" do
    command "lxc-stop -n #{new_resource.lxc_name}"
  end
end


action :start do
  execute "stopping-lxc-#{new_resource.name}" do
    command "lxc-start -n #{new_resource.lxc_name} -d"
  end
end


action :destroy do
  execute "destroy-lxc-#{new_resource.lxc_name}" do
    command "lxc-stop -k -n #{new_resource.lxc_name}; lxc-destroy -n #{new_resource.lxc_name}"
    only_if "lxc-ls | grep #{new_resource.lxc_name}"
  end
end
