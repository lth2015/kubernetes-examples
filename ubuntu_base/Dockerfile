FROM registry.test.com:5000/ubuntu:latest

MAINTAINER yong.li-1@company.com

ADD profile /etc/
ADD locale /etc/default/

ENV LANG en_US.UTF-8

RUN sed -i '/archive.ubuntu.com/s/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install telnet -y
RUN apt-get install gcc -y
RUN apt-get install make -y
RUN apt-get install dnsutils -y
RUN apt-get install wget -y
RUN apt-get install curl -y
RUN apt-get install gdb -y
RUN apt-get install traceroute -y
RUN apt-get install net-tools iputils-ping -y
RUN apt-get install -y language-pack-zh-hans
RUN echo "Asia/Shanghai" > /etc/timezone
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN locale-gen en_US.UTF-8
