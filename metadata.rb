name             'lxc_manage'
maintainer       'Copyright (C) 2019 Chris Hammer'
maintainer_email 'chris@thezengarden.net'
license          'GPL-2.0'
description      'Installs/Configures lxc_manage'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.4'
issues_url       'http://www.thezengarden.net'
source_url       'http://www.thezengarden.net'
chef_version     '>= 12.5' if respond_to?(:chef_version)
supports         'centos', '>= 7.0'

