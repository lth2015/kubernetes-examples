FROM ubuntu-base:v2
MAINTAINER dawei.li@company.com

ADD tomcat7-40-tomcat-push-portal/ /apps/product/tomcat7
RUN mkdir -p /apps/log
RUN mkdir -p /apps/log/tomcat-access/
RUN mkdir -p /apps/log/tomcat-nohup/
ADD dbconfig/  /apps/dbconfig/

# RUN chown -Rf app:app /apps
# RUN chown -Rf app:app /apps/product/tomcat7
# USER app

ENTRYPOINT [ "/apps/product/tomcat7/bin/catalina.sh", "run" ]
