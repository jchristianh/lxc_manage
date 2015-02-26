#
# Cookbook Name:: lxc_manage
# Recipe:: packages
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#

# Include our ZEN::Package module:
::Chef::Recipe.send(:include, ZEN::Package)


# Package list to install:
pkg_list = ['lxc','lxc-templates']


# Call to ZEN::Package to install
# the list of packages above:
install_pkgs (pkg_list)
