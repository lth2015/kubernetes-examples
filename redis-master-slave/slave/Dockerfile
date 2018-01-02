FROM redis:latest

RUN mkdir /etc/redis

RUN mkdir -p /var/lib/redis

RUN mkdir -p /var/log/redis

ADD redis.conf /etc/redis/

ADD entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
