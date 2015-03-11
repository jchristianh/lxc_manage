#
# Cookbook Name:: lxc_manage
# Libraries:: helper
#
# Copyright 2015, Copyright (C) 2015 The Zen Garden. All rights reserved.
#
# All rights reserved - Do Not Redistribute
#


# We use OpenSSL to generate a random MAC address for each node.
# LXC seems to prefix its generated addresses with 'fe', so
# that's what we're going to adhere to.
def generate_mac
  mac = `openssl rand -hex 6`.chomp
  mac = mac.scan(/.{1,2}/).join(":")

  if (mac =~ /^fe:/)
    return mac
  else
    generate_mac
  end
end
