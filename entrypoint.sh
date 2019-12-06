#!/bin/sh

# Docker Entrypoint, generates logrotate config file, sets up crontab and hand over to `tini`
export CURRENT_USER=`whoami`
cat /logrotate.tpl.conf | envsubst > /etc/logrotate.conf

echo "$CRON_SCHEDULE /usr/sbin/logrotate /etc/logrotate.conf" | crontab -

exec tini $@
