#
# Cookbook Name:: lxc_manage
# Libraries:: helper
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


# Generate and return a MAC address for a network interface:
def generate_mac
  mac = `openssl rand -hex 6`.chomp
  mac = mac.scan(/.{1,2}/).join(":")

  if (mac =~ /^fe:/)
    return mac
  else
    generate_mac
  end
end
