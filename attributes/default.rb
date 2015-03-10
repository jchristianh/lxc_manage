#
# Cookbook Name:: lxc_manage
# Attributes:: default
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


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
