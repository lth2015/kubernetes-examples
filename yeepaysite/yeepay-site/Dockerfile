#################################################### 
# For Node.js (www.company.com) 
####################################################
 
FROM company/nodejs-base
MAINTAINER lidawei dawei.li@company.com

RUN mkdir /usr/local/company-site
#RUN mkdir /usr/local/company-img/output
ADD company /usr/local/company-site

RUN cd /usr/local/company-site

WORKDIR /usr/local/company-site

EXPOSE 8080

ENTRYPOINT ["/usr/bin/node", "company.js"]
