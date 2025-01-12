FROM alpine:3.10

ENV CRON_SCHEDULE='* * * * *' \
    LOGROTATE_PATTERN='/logs/*.log' \
    LOGROTATE_OPTIONS=''

RUN apk --no-cache add logrotate tini gettext \
    && mkdir -p /logs \
    && mkdir -p /etc/logrotate.d

COPY logrotate.tpl.conf /logrotate.tpl.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/sbin/crond", "-f", "-L", "/dev/stdout"]
