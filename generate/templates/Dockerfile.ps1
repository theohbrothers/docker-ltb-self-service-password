@'
# Use this container to download the .deb because the SSL certs are expired in phusion/baseimage:0.9.16
FROM alpine:3.14 AS build
RUN wget -q https://ltb-project.org/archives/self-service-password_1.3-1_all.deb -O /self-service-password.deb

FROM phusion/baseimage:0.9.16 AS final

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV DEBIAN_FRONTEND noninteractive

# Install Apache2, PHP and LTB ssp
RUN apt-get update && apt-get install -y ca-certificates apache2 php5 php5-mcrypt php5-ldap && apt-get clean
COPY --from=build /self-service-password.deb .
RUN dpkg -i self-service-password.deb ; rm -f self-service-password.deb

# Log to stdout
RUN sed -i 's#/var/log/apache2/ssp_error.log#/dev/stdout#g' `dpkg -L self-service-password | grep -w 'self-service-password\.conf'` \
    && sed -i 's#/var/log/apache2/ssp_access.log#/dev/stdout#g' `dpkg -L self-service-password | grep -w 'self-service-password\.conf'`

# Configure self-service-password site
RUN ln -s ../../mods-available/mcrypt.ini /etc/php5/apache2/conf.d/20-mcrypt.ini
RUN a2dissite 000-default && a2ensite self-service-password

# This is where configuration goes
ADD assets/config.inc.php /usr/share/self-service-password/conf/config.inc.php

# Start Apache2 as runit service
RUN mkdir /etc/service/apache2
ADD assets/apache2.sh /etc/service/apache2/run

EXPOSE 80

'@
