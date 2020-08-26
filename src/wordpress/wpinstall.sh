#!/bin/sh
cd /www
wp core is-installed
if [ $? == 1 ]; then
    echo "wp core is-installed has exit status 1"
	wp core download
	wp core install --url=wordpress/ --path=/www --title"Wordpress" --admin_user="admin" --admin_password="pass" --admin_email="vtenneke@student.codam.nl" -- skip-email
	wp term create category Test

	wp user create steve journalist@example.com --role=journalist --user_pass=pass
	wp user create George jungleman@example.com --role=jungleman --user_pass=pass
	wp user create Charles officer@example.com --role=officer --user_pass=pass

    wp theme install twentyten
    wp theme install twentytwenty
    wp theme activate twentyten
    wp plugin install woocommerce
else
	echo "wp core is-installed has exit status NOT 1"
    echo "Wordpress was already installed in the /www directory"
fi