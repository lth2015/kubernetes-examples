FROM ubuntu:14.04
MAINTAINER dawei.li@company.com

RUN apt-get update -y
RUN apt-get -y install wget supervisor

WORKDIR /opt
RUN wget --no-check-certificate -O- https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz | tar xvfz - 
RUN mkdir /etc/kibana # This is where the htpasswd file is placed by the run script

# ADD kibana /etc/nginx/sites-available/kibana
# ADD kibana-secure /etc/nginx/sites-available/kibana-secure
# RUN rm /etc/nginx/sites-enabled/*
# RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# ENV KIBANA_SECURE true
# ENV KIBANA_USER kibana
# ENV KIBANA_PASSWORD kibana

EXPOSE 80

ADD supervisord.conf /etc/supervisor/conf.d/kibana.conf

# ADD run ./run
# RUN chmod +x ./run
# CMD ./run
