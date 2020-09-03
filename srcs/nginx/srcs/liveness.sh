#!bin/sh
pidof nginx
if [ $? == 1 ]
then
exit 1
fi
pidof sshd
if [ $? == 1 ]
then
exit 1
fi