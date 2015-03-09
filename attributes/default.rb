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


# Node definitions:
#
# cnode6 = container name/hostname
# type   = lxc template name
# lxc_version = image version
# hwaddr = can put anything here; mac will be auto generated
# active = true/false; true creates; false destroys
###########################################################
default['lxc_container']['node']['cnode6']['type']        = "centos"
default['lxc_container']['node']['cnode6']['lxc_version'] = "7"
default['lxc_container']['node']['cnode6']['active']      = true
default['lxc_container']['node']['cnode6']['run']         = true
default['lxc_container']['node']['cnode6']['autostart']   = true
default['lxc_container']['node']['cnode6']['startdelay']  = 10
default['lxc_container']['node']['cnode6']['startorder']  = 10
default['lxc_container']['node']['cnode6']['group']       = "onboot"
default['lxc_container']['node']['cnode6']['ipaddr']      = "10.10.10.124"
default['lxc_container']['node']['cnode6']['ipcidr']      = "27"
default['lxc_container']['node']['cnode6']['ipgateway']   = "10.10.10.126"


default['lxc_container']['node']['cnode7']['type']        = "centos"
default['lxc_container']['node']['cnode7']['lxc_version'] = "7"
default['lxc_container']['node']['cnode7']['active']      = false
default['lxc_container']['node']['cnode7']['run']         = false
default['lxc_container']['node']['cnode7']['autostart']   = true
default['lxc_container']['node']['cnode7']['startdelay']  = 10
default['lxc_container']['node']['cnode7']['startorder']  = 10
default['lxc_container']['node']['cnode7']['group']       = "onboot"
default['lxc_container']['node']['cnode7']['ipaddr']      = "10.10.10.125"
default['lxc_container']['node']['cnode7']['ipcidr']      = "27"
default['lxc_container']['node']['cnode7']['ipgateway']   = "10.10.10.126"
