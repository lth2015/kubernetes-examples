FROM ubuntu
ADD bin /usr/local/bin
RUN chmod +x /usr/local/bin
#RUN chmod +x /tmp/ping.sh
#ENTRYPOINT ["ping", "192.168.162.167 >/tmp/ping"]
ENTRYPOINT ["/usr/local/bin/test"]
