#
# Cookbook Name:: lxc_manage
# Libraries:: helper
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


# We use OpenSSL to generate a random MAC address for each node.
# LXC seems to prefix its generated addresses with 'fe', so
# that's what we're going to adhere to.
def generate_mac
  mac = Mixlib::ShellOut.new('openssl rand -hex 6')
  mac.run_command
  mac = mac.stdout.chomp.scan(/.{1,2}/).join(":")

  if (mac =~ /^fe:/)
    return mac
  else
    generate_mac
  end
end
