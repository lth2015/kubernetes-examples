#################################################### 
# For Node.js (www.company.com) 
####################################################
 
FROM company/nodejs-base
MAINTAINER lidawei dawei.li@company.com

RUN mkdir /usr/local/donate_wap
RUN mkdir /usr/local/donate_wap/output
ADD donate_wap /usr/local/donate_wap

RUN cd /usr/local/donate_wap

WORKDIR /usr/local/donate_wap

EXPOSE 8080

ENTRYPOINT ["/usr/bin/npm", "start"]
