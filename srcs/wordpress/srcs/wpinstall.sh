#!/bin/sh
cd /www
wp core is-installed
if [ $? == 1 ]; then
    wp core download
    wp core install --url=wordpress/ --path=/www --title="$WP_TITLE" --admin_user="$WP_USER" --admin_password="$WP_PASSWORD" --admin_email=admin@system.com --skip-email
    wp term create category Test
    wp post create --post_author=admin --post_category="Test" --post-title="Test Title" --post-content="yeet" --post_excerpt=tag --post_status=publish | awk '{gsub(/[.]/, ""); print $4}' > /tmp/postid

    wp user create user1 editor@example.com --role=editor --user_pass=editor
    wp user create user2 author@example.com --role=author --user_pass=author
    wp user create user3 contributor@example.com --role=contributor --user_pass=contributor
    wp user create user4 subscriber@example.com --role=subscriber --user_pass=subscriber

    wp theme install winter
    wp theme install twentyten
    wp theme install twentytwenty
    wp theme activate twentytwenty
    wp plugin install woocommerce
fi
