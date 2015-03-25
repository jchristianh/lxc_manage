#
# Cookbook Name:: lxc_manage
# Attributes:: default
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


# DEFAULTS
default['lxc_container']['path']       = "/var/lib/lxc"
default['lxc_container']['def_domain'] = "thezengarden.net"


# This will be re-documented soon...
###########################################################
default['lxc_container']['node']['cnode6']['type']            = "centos"
default['lxc_container']['node']['cnode6']['lxc_version']     = "7"
default['lxc_container']['node']['cnode6']['active']          = false
default['lxc_container']['node']['cnode6']['run']             = true
default['lxc_container']['node']['cnode6']['autostart']       = true
default['lxc_container']['node']['cnode6']['startdelay']      = 10
default['lxc_container']['node']['cnode6']['startorder']      = 1
default['lxc_container']['node']['cnode6']['group']           = "onboot"
default['lxc_container']['node']['cnode6']['network'] = {
  "eth0" => {
    "ip_address" => "10.10.10.124",
    "ip_cidr"    => "27",
    "gateway"    => "10.10.10.126",
  },
  "eth1" => {
    "ip_address" => "10.10.10.125",
    "ip_cidr"    => "27",
    "gateway"    => "10.10.10.126",
  }
}


default['lxc_container']['node']['cnode7']['type']            = "centos"
default['lxc_container']['node']['cnode7']['lxc_version']     = "7"
default['lxc_container']['node']['cnode7']['active']          = false
default['lxc_container']['node']['cnode7']['run']             = true
default['lxc_container']['node']['cnode7']['autostart']       = true
default['lxc_container']['node']['cnode7']['startdelay']      = 10
default['lxc_container']['node']['cnode7']['startorder']      = 2
default['lxc_container']['node']['cnode7']['group']           = "onboot"
default['lxc_container']['node']['cnode7']['network'] = {
  "eth0" => {
    "ip_address" => "10.10.10.121",
    "ip_cidr"    => "27",
    "gateway"    => "10.10.10.126",
  }
}
