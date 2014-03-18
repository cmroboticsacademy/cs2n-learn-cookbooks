cron "moodle_cron" do
  minute "*/59"
  command "php /srv/www/cs2n-learn/current/admin/cron.php"
end