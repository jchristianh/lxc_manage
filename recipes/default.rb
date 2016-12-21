#
# Cookbooklxc_node['id']:: lxc_manage
# Recipe:: default
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


# Install LXC Packages:
include_recipe "lxc_manage::packages"


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
      lxc_manage_node "update-conf-#{lxc_node['id']}" do
        lxc_name lxc_node['id']
        lxc_ver  lxc_node['version'] if lxc_node['version']
        lxc_vars lxc_node
        action :update_conf
        only_if "lxc-ls | grep #{lxc_node['id']}"
        # not_if "lxc-ls --active | grep #{lxc_node['id']}"
      end
    else
      lxc_manage_node "update-conf-#{lxc_node['id']}" do
        lxc_name lxc_node['id']
        lxc_ver  lxc_node['version'] if lxc_node['version']
        lxc_vars lxc_node
        action :update_conf
        only_if "lxc-ls | grep #{lxc_node['id']}"
        # not_if "lxc-ls --active | grep #{lxc_node['id']}"
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
