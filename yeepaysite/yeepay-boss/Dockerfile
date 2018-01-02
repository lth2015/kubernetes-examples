#################################################### 
# For Node.js (www.company.com) 
####################################################
 
FROM company/nodejs-base
MAINTAINER lidawei dawei.li@company.com

RUN mkdir /usr/local/company-boss
#RUN mkdir /usr/local/company-img/output
ADD company-boss /usr/local/company-boss

RUN cd /usr/local/company-boss

WORKDIR /usr/local/company-boss

EXPOSE 8080

ENTRYPOINT ["/usr/bin/node", "company-boss.js"]
