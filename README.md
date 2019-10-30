docker-ltb-self-service-password
================================

<!--
[![Build Status](https://travis-ci.org/leojonathanoh/docker-LTB-self-service-password.svg?branch=master)](https://travis-ci.org/leojonathanoh/docker-LTB-self-service-password)
-->

[![github-actions](https://github.com/leojonathanoh/docker-ltb-self-service-password/workflows/build/badge.svg)](https://github.com/leojonathanoh/docker-ltb-self-service-password/actions)
[![github-tag](https://img.shields.io/github/tag/leojonathanoh/docker-ltb-self-service-password)](https://github.com/leojonathanoh/docker-ltb-self-service-password/releases/)
[![docker-image-size](https://img.shields.io/microbadger/image-size/leojonathanoh/docker-ltb-self-service-password/latest)](https://hub.docker.com/r/leojonathanoh/docker-ltb-self-service-password)
[![docker-image-layers](https://img.shields.io/microbadger/layers/leojonathanoh/docker-ltb-self-service-password/latest)](https://hub.docker.com/r/leojonathanoh/docker-ltb-self-service-password)

A dockerfile for the LDAP ToolBox (LTB) Self Service Password utility, which is a PHP application that allows users to change their password in an LDAP directory. See http://ltb-project.org/wiki/documentation/self-service-password

## Quick Start
You can either run the image and link it to an external configuration file, or you can rebuild your own standalone image.

#### Running from the image, i.e. the `--with-volume` way
Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull leojonathanoh/docker-ltb-self-service-password:v1.3
```

Then, provide your own `config.inc.php` file, downloaded from   http://tools.ltb-project.org/projects/ltb/repository/entry/self-service-password/tags/0.8/conf/config.inc.php and modified according to your settings.

You can now run container:
* in foreground:
```bash
docker run -it --rm -p 8765:80 -v /path/to/config.inc.php:/usr/share/self-service-password/conf/config.inc.php leojonathanoh/docker-ltb-self-service-password:v1.3
```
* as a daemon:
```bash
docker run -d -p 8765:80 -v /path/to/config.inc.php:/usr/share/self-service-password/conf/config.inc.php leojonathanoh/docker-ltb-self-service-password:v1.3
```

The examples above expose service on port `8765`, so you can point your browser to http://hostname:8765/ in order to change LDAP passwords.

#### Building the image yourself

```bash
git clone https://github.com/grams/docker-LTB-self-service-password.git
cd docker-LTB-self-service-password
```
Edit `assets/config.inc.php` according to your local settings, then (re)build image with:
```bash
docker build -t="$USER/ltb-self-service-password" .
```
You can now run container:
* in foreground:
```bash
docker run -it --rm -p 8765:80 $USER/ltb-self-service-password
```
* as a daemon:
```bash
docker run -d -p 8765:80 $USER/ltb-self-service-password
```

## Troubleshooting

#### What's going on ?
You can debug LDAP connection problems by adding this line in  `config.inc.php`:
```php
ldap_set_option(NULL, LDAP_OPT_DEBUG_LEVEL, 7);
```
Then inspect apache logs of a runnning container:
```bash
docker exec -ti $(docker ps | grep 'ltb-self-service-password' | awk '{print $1}') tail /var/log/apache2/error.log
```

#### LDAPS with self-signed certificate
When connecting with LDAPS protocol to a server wtih a self-signed certificate, you will see this error in apache logs:
```
TLS: peer cert untrusted or revoked (0x42)
TLS: can't connect: (unknown error code).
```
Add this into `config.inc.php` to disable all certificate validation:
```php
putenv('LDAPTLS_REQCERT=never');
```

