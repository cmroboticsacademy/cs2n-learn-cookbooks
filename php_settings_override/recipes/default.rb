# allows it to restart the apache2 service
include_recipe "apache2::service"
 
# make php show errors
file "/etc/php5/apache2/conf.d/cs2n-learn.ini" do
  content <<-EOH
  
  ; Maximum allowed size for uploaded files.
  ; http://php.net/upload-max-filesize
  upload_max_filesize = 64M
  post_max_size = 64M
 
  EOH
  notifies :restart, resources(:service => 'apache2')
end