name              'php'
maintainer        'Opscode, Inc.'
maintainer_email  'cookbooks@opscode.com'
license           'Apache 2.0'
description       'Installs and maintains php and php modules'
version           '1.3.10'

%w{ debian ubuntu centos redhat fedora scientific amazon windows }.each do |os|
  supports os
end
