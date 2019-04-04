#
# Cookbook Name:: lxc_manage
# Providers:: manage_node
#
# Copyright (C) 2015 Chris Hammer <chris@thezengarden.net>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/gpl-2.0.txt>.


action :create do

  # Some vars to increase code readability
  def_domain   = node["lxc_container"]["def_domain"]
  lxc_base     = node["lxc_container"]["path"] + "/" + new_resource.lxc_name
  lxc_type     = new_resource.lxc_vars['type']    || "centos"
  lxc_ver      = new_resource.lxc_vars['version'] || false
  rootfs       = lxc_base + "/rootfs"
  lxc_conf     = lxc_base + "/config"
  lxc_opts     = ''
  autostart    = new_resource.lxc_vars['autostart']
  startdelay   = new_resource.lxc_vars['startdelay'] || 0
  startorder   = new_resource.lxc_vars['startorder'] || 1
  lxcgroup     = new_resource.lxc_vars['group']      || "ungrouped"
  limit_cpu    = new_resource.lxc_vars['limit_cpu'] || false


  if (lxc_ver)
    lxc_opts = "-- --release=#{lxc_ver}"
  end


  execute "create-lxc-#{new_resource.lxc_name}" do
    command "lxc-create -t #{lxc_type} -n #{new_resource.lxc_name} #{lxc_opts}"
    not_if "lxc-ls | grep #{new_resource.lxc_name}"
  end


  # Create a backup of the LXC generated config:
  execute "backup-#{lxc_conf}" do
    command "mv #{lxc_conf} #{lxc_conf}.dist"
    not_if { ::File.exist?("#{lxc_conf}.dist") }
  end


  ruby_block "mac_addr_#{new_resource.name}" do
    block do
      if (new_resource.lxc_vars.has_key?("network"))
        new_resource.lxc_vars['network'].each do |dev,_vars|
          gen_mac = generate_mac
          node.normal['lxc_container']['node'][new_resource.lxc_name]['network'][dev]['hwaddr'] = gen_mac
        end
      else
        gen_mac = generate_mac
        node.normal["lxc_container"]["node"][new_resource.lxc_name]["network"]["eth0"]["hwaddr"] = gen_mac
      end
    end
  end


  if (new_resource.lxc_vars.has_key?("network"))
    new_resource.lxc_vars['network'].each do |dev,vars|
      template "#{lxc_base}/rootfs/etc/sysconfig/network-scripts/ifcfg-#{dev}" do
        source "ifcfg.erb"

        variables( lazy {
          {
            :network_device => dev,
            :hwaddr         => node["lxc_container"]["node"][new_resource.lxc_name]["network"][dev]["hwaddr"],
            :ipaddr         => vars['ip'],
            :ipcidr         => vars['cidr'],
            :ipgateway      => vars['gw']
          }
        })
      end
    end


    cookbook_file "#{lxc_base}/rootfs/etc/sysctl.d/99-rp_filter.conf" do
      source "99-rp_filter.conf"
      owner  "root"
      group  "root"
      mode   "0644"

      only_if { lxc_type == "centos" && (lxc_ver == false || lxc_ver == "7") }
    end
  end


  template lxc_conf do
    source "container_config.erb"

    variables( lazy {
      {
        :rootfs       => rootfs,
        :utsname_pre  => new_resource.lxc_name,
        :utsname_post => def_domain,
        :network      => new_resource.lxc_vars['network'],
        :autostart    => autostart,
        :start_delay  => startdelay,
        :start_order  => startorder,
        :group        => lxcgroup,
        :limit_cpu    => limit_cpu,
        :cpu_cores    => new_resource.lxc_vars['cpu_cores'],
        :cpu_shares   => new_resource.lxc_vars['cpu_shares']
      }
    })

    only_if { ::File.exist?("#{lxc_conf}.dist") }
  end
end


action :update_conf do
  def_domain   = node["lxc_container"]["def_domain"]
  lxc_base     = node["lxc_container"]["path"] + "/" + new_resource.lxc_name
  lxc_type     = new_resource.lxc_vars['type']    || "centos"
  lxc_ver      = new_resource.lxc_vars['version'] || false
  rootfs       = lxc_base + "/rootfs"
  lxc_conf     = lxc_base + "/config"
  autostart    = new_resource.lxc_vars['autostart']
  startdelay   = new_resource.lxc_vars['startdelay'] || 0
  startorder   = new_resource.lxc_vars['startorder'] || 1
  lxcgroup     = new_resource.lxc_vars['group']      || "ungrouped"
  limit_cpu    = new_resource.lxc_vars['limit_cpu'] || false


  if (new_resource.lxc_vars.has_key?("network"))
    new_resource.lxc_vars['network'].each do |dev,vars|
      template "#{lxc_base}/rootfs/etc/sysconfig/network-scripts/ifcfg-#{dev}" do
        source "ifcfg.erb"

        variables( lazy {
          {
            :network_device => dev,
            :hwaddr         => node["lxc_container"]["node"][new_resource.lxc_name]["network"][dev]["hwaddr"],
            :ipaddr         => vars['ip'],
            :ipcidr         => vars['cidr'],
            :ipgateway      => vars['gw']
          }
        })
      end
    end
  else
    template "#{lxc_base}/rootfs/etc/sysconfig/network-scripts/ifcfg-eth0" do
      source "ifcfg.erb"

      variables({
        :lxc_name => new_resource.lxc_name
      })
    end
  end


  cookbook_file "#{lxc_base}/rootfs/etc/sysctl.d/99-rp_filter.conf" do
    source "99-rp_filter.conf"
    owner  "root"
    group  "root"
    mode   "0644"

    only_if { lxc_type == "centos" && (lxc_ver == false || lxc_ver == "7") }
  end


  template lxc_conf do
    source "container_config.erb"

    variables( lazy {
      {
        :rootfs       => rootfs,
        :utsname_pre  => new_resource.lxc_name,
        :utsname_post => def_domain,
        :network      => new_resource.lxc_vars['network'],
        :autostart    => autostart,
        :start_delay  => startdelay,
        :start_order  => startorder,
        :group        => lxcgroup,
        :limit_cpu    => limit_cpu,
        :cpu_cores    => new_resource.lxc_vars['cpu_cores'],
        :cpu_shares   => new_resource.lxc_vars['cpu_shares']
      }
    })

    only_if { ::File.exist?("#{lxc_conf}.dist") }
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
    command "lxc-stop -n #{new_resource.lxc_name}; lxc-destroy -n #{new_resource.lxc_name}"
    only_if "lxc-ls | grep #{new_resource.lxc_name}"
  end

  node.rm("lxc_container", "node", new_resource.lxc_name)
end
