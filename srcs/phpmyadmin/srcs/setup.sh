envsubst '${DB_HOST}' < /tmp/config.inc.php > /www/config.inc.php
chown -R www:www /var/lib/nginx
chown -R www:www /www