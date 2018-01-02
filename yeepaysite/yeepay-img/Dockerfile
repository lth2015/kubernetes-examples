#################################################### 
# For Node.js (www.company.com) 
####################################################
 
FROM company/nodejs-base
MAINTAINER lidawei dawei.li@company.com

RUN mkdir /usr/local/company-img
RUN mkdir /usr/local/company-img/output
ADD company-img /usr/local/company-img

RUN cd /usr/local/company-img

WORKDIR /usr/local/company-img

EXPOSE 8080

ENTRYPOINT ["/usr/bin/node", "img-server.js"]
