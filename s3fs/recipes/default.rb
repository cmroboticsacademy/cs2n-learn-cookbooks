%w{ pkg-config build-essential libcurl4-openssl-dev libxml2-dev mime-support }.each do |pkg|
  package pkg
end

cookbook_file "/tmp/fuse-2.9.3.tar.gz" do
  source "fuse-2.9.3.tar.gz"
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


cookbook_file "/tmp/s3fs-1.74.tar.gz" do
  source "s3fs-1.74.tar.gz"
  mode 0644
end

bash "set passwd-s3fs" do
  cwd "/tmp"
  code <<-EOH
  sudo echo "AKIAJJBZOV74Z25E42UQ:KYA5VLO2Azybu5VRheB30x65LZOUymfQeZfQTPZe" | sudo tee /etc/passwd-s3fs
  sudo chmod 640 /etc/passwd-s3fs

  EOH
  
  not_if { File.exists?("/etc/passwd-s3fs") }
end

bash "install s3fs mount drives for first time" do
  cwd "/tmp"
  code <<-EOH
  tar zxvf s3fs-1.74.tar.gz
  cd s3fs-1.74
  sudo ./configure --prefix=/usr
  make
  sudo make install

  sudo mkdir -p /mnt/moodledata_temp
  sudo chown www-data:www-data /mnt/moodledata_temp
  
  sudo mkdir -p /mnt/moodledata_temp/filedir
  sudo chown www-data:www-data /mnt/moodledata_temp/filedir

  sudo mkdir -p /mnt/moodledatacache_temp
  sudo chown www-data:www-data /mnt/moodledatacache_temp

  sudo /usr/bin/s3fs cmu-moodle-files -o allow_other -ouse_cache=/mnt/moodledatacache_temp /mnt/moodledata_temp/filedir

  EOH
  
  not_if { File.exists?("/usr/bin/s3fs") }
end

cookbook_file value_for_platform([ "centos", "redhat", "fedora", "suse" ] => {"default" => "/etc/init.d/rc.local"}, "default" => "/etc/init.d/rc.local") do
  source "rc.local"
  owner "root"
  group "root"
  mode 0755
end




