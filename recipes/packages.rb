#
# Cookbook Name:: lxc_manage
# Recipe:: packages
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


# Package list to install:
pkg_list = ['lxc','lxc-templates','lxc-extra','debootstrap']


# If we're not running in the Production environment,
# we will update all packages on each run:
execute "yummy-update" do
  command "yum update -y"
  only_if { node.environment != "Production" }
end


# Once all base packages have been updated, lets install
# a base set of packages that should be on every node of ours:
if pkg_list.class == Array
  pkg_list.each do |pkg|
    package pkg do
      action :install
    end
  end
else
  package pkg_list do
    action :install
  end
end
