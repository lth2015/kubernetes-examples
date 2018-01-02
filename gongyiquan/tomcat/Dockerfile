FROM company/jdk1.6.0_45
MAINTAINER dawei.li@company.com 

ADD tomcat-commonweal/ /apps/tomcat-commonweal/

RUN mkdir -p /apps/log/tomcat-nohup/

WORKDIR /apps/tomcat-commonweal/bin

EXPOSE 8080

# CMD ["/apps/tomcat-commonweal/bin/startup.sh"]
# ENTRYPOINT["tail -f /apps/tomcat-commonweal/logs/"]

ENTRYPOINT ["/apps/tomcat-commonweal/bin/catalina.sh", "run"]
