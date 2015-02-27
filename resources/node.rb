#
# Cookbook Name:: lxc_manage
# Resources:: manage_node
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


actions :create, :destroy

attribute :name,     :name_attribute => true
attribute :lxc_name, :kind_of        => String, :required => true
attribute :lxc_vars, :kind_of        => Array
