FROM ubuntu-base:v1
MAINTAINER dawei.li@company.com

ADD tomcat7-42-tomcat-android-pns-core/ /apps/product/tomcat7
RUN mkdir -p /apps/log
RUN mkdir -p /apps/log/tomcat-access/
RUN mkdir -p /apps/log/tomcat-nohup/
ADD dbconfig/  /apps/dbconfig/

# RUN chown -Rf app:app /apps
# USER app

ENTRYPOINT [ "/apps/product/tomcat7/bin/catalina.sh", "run" ]
