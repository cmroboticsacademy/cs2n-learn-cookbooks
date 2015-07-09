cron "moodle_cron" do
  minute "*/59"
  command "php /srv/www/cs2n_learn/current/admin/cli/cron.php"
end

cron "moodle_purge_cache" do
  hour "12"
  minute "0"
  command "php /srv/www/cs2n_learn/current/admin/cli/purge_caches.php"
end