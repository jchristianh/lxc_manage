#
# Cookbook Name:: lxc_manage
# Attributes:: default
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


# Node definitions:
#
# cnode6 = container name/hostname
# type   = lxc template name
# lxc_version = image version
# hwaddr = can put anything her; mac will be auto generated
# active = true/false; true creates; false destroys
###########################################################
default['lxc_container']['node']['cnode6']['type']        = "centos"
default['lxc_container']['node']['cnode6']['lxc_version'] = "7"
default['lxc_container']['node']['cnode6']['hwaddr']      = "aa:aa:aa:aa:aa:aa"
default['lxc_container']['node']['cnode6']['active']      = true


default['lxc_container']['node']['cnode7']['type']        = "centos"
default['lxc_container']['node']['cnode7']['lxc_version'] = "7"
default['lxc_container']['node']['cnode7']['hwaddr']      = "aa:aa:aa:aa:aa:aa"
default['lxc_container']['node']['cnode7']['active']      = true
