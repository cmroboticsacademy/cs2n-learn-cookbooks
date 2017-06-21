cron "moodle_cron" do
  minute "*/30"
  command "php /srv/www/cs2n_learn/current/admin/cli/cron.php"
end

cron "moodle_purge_cache" do
  minute "*/30"
  command "php /srv/www/cs2n_learn/current/admin/cli/purge_caches.php"
end