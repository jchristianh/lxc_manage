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
  lxc_run      = new_resource.lxc_vars['run'] || false
  rootfs       = lxc_base + "/rootfs"
  lxc_conf     = lxc_base + "/config"
  lxc_opts     = ''
  autostart    = new_resource.lxc_vars['autostart']
  startdelay   = new_resource.lxc_vars['startdelay'] || 0
  startorder   = new_resource.lxc_vars['startorder'] || 1
  lxcgroup     = new_resource.lxc_vars['group']      || "ungrouped"


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
  #
  # This is not going to work as written.
  ruby_block "mac_addr_#{new_resource.name}" do
    block do
      if (new_resource.lxc_vars.has_key?("network"))
        new_resource.lxc_vars['network'].each do |dev,vars|
          gen_mac = generate_mac
          node.set['lxc_container']['node']["#{new_resource.lxc_name}"]['network']["#{dev}"]['hwaddr'] = gen_mac
          node.save
        end
      else
        gen_mac = generate_mac
        node.set["lxc_container"]["node"]["#{new_resource.lxc_name}"]["network"]["eth0"]["hwaddr"] = gen_mac
        node.save
      end
    end
  end


  if (new_resource.lxc_vars.has_key?("network"))
    new_resource.lxc_vars['network'].each do |dev,vars|
      template "#{lxc_base}/rootfs/etc/sysconfig/network-scripts/ifcfg-#{dev}" do
        source "ifcfg.erb"

        variables ( lazy {
          {
            :network_device => dev,
            :hwaddr         => node["lxc_container"]["node"]["#{new_resource.lxc_name}"]["network"]["#{dev}"]["hwaddr"],
            :ipaddr         => new_resource.lxc_vars['network']["#{dev}"]["ip_address"],
            :ipcidr         => new_resource.lxc_vars['network']["#{dev}"]["ip_cidr"],
            :ipgateway      => new_resource.lxc_vars['network']["#{dev}"]["gateway"]
          }
        })
      end
    end
  end


  template "#{lxc_conf}" do
    source "container_config.erb"

    variables ( lazy {
      {
        :rootfs      => rootfs,
        :utsname     => new_resource.lxc_name + "." + def_domain,
        :network     => new_resource.lxc_vars['network'],
        :autostart   => autostart,
        :start_delay => startdelay,
        :start_order => startorder,
        :group       => lxcgroup
      }
    })

    only_if { ::File.exists?("#{lxc_conf}.dist") }
  end
end


action :stop do
  execute "stopping-lxc-#{new_resource.name}" do
    command "lxc-stop -n #{new_resource.lxc_name}"
  end
end


action :start do
  execute "starting-lxc-#{new_resource.name}" do
    command "lxc-start -n #{new_resource.lxc_name} -d"
  end
end


action :destroy do
  execute "destroy-lxc-#{new_resource.lxc_name}" do
    command "lxc-stop -k -n #{new_resource.lxc_name}; lxc-destroy -n #{new_resource.lxc_name}"
    only_if "lxc-ls | grep #{new_resource.lxc_name}"
  end
end
