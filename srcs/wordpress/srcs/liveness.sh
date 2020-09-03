#!bin/sh
pidof nginx
if [ $? == 1 ]
then
exit 1
fi
pidof php-fpm7
if [ $? == 1 ]
then
exit 1
fi