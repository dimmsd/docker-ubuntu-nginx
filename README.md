[![Build Status](https://travis-ci.org/dimmsd/docker-ubuntu-nginx.svg?branch=master)](https://travis-ci.org/dimmsd/docker-ubuntu-nginx)
## Ubuntu Nginx image

[The Docker Hub page](https://hub.docker.com/r/dimmsd/ubuntu-nginx)

Image size  202 MB

Squashing images with [docker-squash](https://github.com/goldmann/docker-squash) 170 MB

Ubuntu 16.04 + Nginx 1.14.0

Image tag 16.04.1.14.0

Example based on images:

[Ubuntu base image](https://github.com/dimmsd/docker-ubuntu-base)

[Ubuntu PHP-FPM image](https://github.com/dimmsd/docker-ubuntu-php-fpm)

[Ubuntu HTTPD image](https://github.com/dimmsd/docker-ubuntu-httpd)

Nginx (as front-end) + Apache + PHP-FPM

### Using the `Makefile`

```
$ make help
config-test			Test docker-compose.yml
set-log-access			Set permissions for PHP-FPM log
set-www-access			Set permissions for ./www folder : 644 for files and 755 for folders
build				Build a Dockerfile
build-ds			Build a Dockerfile with docker-squash (need instelled docker-sqush)
up				Up service
down				Down service
exec-nginx			Attach to NGINX container and start bash session
exec-httpd			Attach to HTTPD container and start bash session
exec-as-root			Attach to PHP-FPM container and start bash session
exec-as-user			Attach to PHP-FPM container and start bash session under user $(OWN_USER)
fpm-status			Show PHP-FPM status page
fpm-exec-index			Execute /var/www/main/index.php over PHP-FPM
check-site			Execute for test curl $(MAIN_DOMAIN) (from container)
```

### Example

```
$ git clone git://github.com/dimmsd/docker-ubuntu-nginx.git
$ cd docker-ubuntu-nginx
$ cp .env.example .env
$ make build
# or
$ make build-ds
$ make up
```

### Environment

See `.env.example` for detail

Default IP Nginx service in `.env.example` is 172.50.0.100

Default domain is example.loc

For testing example.loc from host system, add host name in `/etc/hosts` file

```
172.50.0.100 example.loc www.example.loc
```

### Run Docker commands without sudo

See this [section](https://github.com/dimmsd/docker-ubuntu-base#run-docker-commands-without-sudo).

