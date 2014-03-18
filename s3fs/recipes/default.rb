%w{ pkg-config build-essential libcurl4-openssl-dev libxml2-dev mime-support }.each do |pkg|
  package pkg
end

remote_file "/tmp/fuse-2.9.3.tar.gz" do
  source "http://downloads.sourceforge.net/project/fuse/fuse-2.X/2.9.3/fuse-2.9.3.tar.gz"
  mode 0644
end

bash "install fuse" do
  cwd "/tmp"
  code <<-EOH
  tar zxvf fuse-2.9.3.tar.gz
  cd fuse-2.9.3
  ./configure --prefix=/usr
  make
  sudo make install
  EOH
  
  not_if {File.exists?("/usr/bin/fusermount")}
end


remote_file "/tmp/s3fs-1.74.tar.gz" do
  source "http://s3fs.googlecode.com/files/s3fs-1.74.tar.gz"
  mode 0644
end

bash "install s3fs" do
  cwd "/tmp"
  code <<-EOH
  tar zxvf s3fs-1.74.tar.gz
  cd s3fs-1.74
  ./configure --prefix=/usr
  make
  sudo make install

  sudo mkdir -p /mnt/moodledata
  sudo chown www-data:www-data /mnt/moodledata
  sudo echo "cmu-moodle-data:AKIAIPAHDQMQZCHO3NWA:ZDAMfDgDymhlN+KQ03jYBKSJyWho8Ez0KumQyzTl" > /etc/passwd-s3fs

  sudo chmod 640 /etc/passwd-s3fs
  sudo mkdir -p /mnt/moodledatacache
  sudo chown www-data:www-data /mnt/moodledatacache

  sudo /usr/bin/s3fs cmu-moodle-data -o allow_other -ouse_cache=/mnt/moodledatacache /mnt/moodledata


  EOH
  
  not_if { File.exists?("/usr/bin/s3fs") }
end

cookbook_file value_for_platform([ "centos", "redhat", "fedora", "suse" ] => {"default" => "/etc/init.d/rc.local"}, "default" => "/etc/init.d/rc.local") do
  source "rc.local"
  owner "root"
  group "root"
  mode 0755
end


