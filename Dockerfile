FROM ubuntu:14.04
MAINTAINER Hervé Bredin "http://herve.niderb.fr"


RUN DEBIAN_FRONTEND=noninteractive apt-get -qy update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qy install curl unzip nginx \
    php5-fpm php5-mysql php5-gd php5-intl php5-imagick \
    php5-mcrypt php5-curl php5-cli php5-xdebug

ADD default-site /etc/nginx/sites-available/default
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini

# download latest piwigo source code
# and unzip it to nginx's /var/www
RUN curl http://piwigo.org/download/dlcounter.php?code=latest -o /tmp/piwigo.zip && \ 
    unzip /tmp/piwigo.zip -d /tmp && \
    mv /tmp/piwigo /var/www && \
    rm -rf /tmp/piwigo /tmp/piwigo.zip

ADD config.inc.php /var/www/local/config/config.inc.php

RUN chmod -R 777 /var/www/plugins && \
    chmod -R 777 /var/www/themes

VOLUME ["/var/www/galleries", "/var/www/upload"]

RUN echo "service php5-fpm start &" >> /run.sh && \
    echo "/usr/sbin/nginx" >> /run.sh

EXPOSE 80

CMD /bin/bash /run.sh
