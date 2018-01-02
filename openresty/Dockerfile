########################################################################################################################################
# Create Images Server with Nginx + Openresty(lua) + Graphicsmagick 
# Documents: https://phpb.com/portfolio/create-image-server-with-nginx-lua-openresty-graphicsmagick-part-1/
########################################################################################################################################
FROM company/ubuntu:14.04
MAINTAINER dawei.li@company.com

########################################################################################################################################
# Goals for implementation of image processing server
# 
# Optimize images for minimum download size and highest quality, have ability to apply further “google pagespeed module” optimizations
# Perform resizing on-the-fly and cache resized and optimised images indefinitely
# Have ability to sign and secure URLs, if needed; optionally allow for URL expiration
# Allow for extensibility and flexibility to add functionality in the future
# Lightweight, able to serve thousands of images per second, once cached
# Full integration with nginx (my web server of choice), no requirement for fcgi or external processing
# No restrictions on usage and terms of use
# And most of all, have a lot of fun learning and experimenting
########################################################################################################################################

# Openresty 
RUN apt-get update -yqq && apt-get install -y libpq-dev libpam-dev libpcre3-dev build-essential libssl-dev libxslt-dev libgeoip-dev
RUN apt-get install -y libgd2-xpm-dev
ADD openresty-1.9.7.4.tar.gz /opt/
WORKDIR /opt/openresty-1.9.7.4
RUN ./configure --with-luajit  --with-http_addition_module --with-http_dav_module --with-http_geoip_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_realip_module --with-http_stub_status_module --with-http_ssl_module --with-http_sub_module --with-http_xslt_module --with-ipv6 --with-http_postgres_module --with-pcre-jit && make && make install 

# RestyBin: /usr/local/openresty/bin

ADD Dockerfile /root/

