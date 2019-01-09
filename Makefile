#!/usr/bin/make

.DEFAULT_GOAL := help
.PHONY : help config-test set-www-access build build-ds make-squash up down exec-nginx exec-httpd exec-as-root- exec-as-user \
 fpm-status fpm-exec-index

cnf ?= .env

ifneq ("$(wildcard $(cnf))","")
include $(cnf)
else
$(error "ERROR! File .env not found. Rename .env.example => .env")
endif

FPMIP=$(shell docker inspect con-$(FPM_IMAGE) | grep '"IPAddress"' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

build-ds: build make-squash

help:
	@echo "Help:"
	@echo "\tconfig-test - Test docker-compose.yml"
	@echo "\tset-www-access - Set permissions for ./www folder: 644 for files and 755 for folders"
	@echo "\tbuild - Build a Dockefile"
	@echo "\tbuild-ds - Build a Dockefile with docker-squash"
	@echo "\tup - Up service"
	@echo "\tdown - Down service"
	@echo "\texec-nginx - Attach to NGINX container and start bash session"
	@echo "\texec-httpd - Attach to HTTPD container and start bash session"
	@echo "\texec-as-root - Attach to PHP-FPM container and start bash session"
	@echo "\texec-as-user - Attach to PHP-FPM container and start bash session under user $(OWN_USER)"
	@echo "\tfpm-status - Show PHP-FPM status page"
	@echo "\tfpm-exec-index - Execute /var/www/main/index.php over PHP-FPM"
	@echo "\tcheck-site - Execute for test curl $(MAIN_DOMAIN) (from container)"
config-test:
	@docker-compose -f docker-compose.yml config
set-www-access:
	find ./www/ -type f -exec chmod 644 {} \;
	find ./www/ -type d -exec chmod 755 {} \;
build:
	@docker-compose build
make-squash:
	@docker-squash -t $(NGINX_IMAGE):$(UBUNTU_VERSION).$(NGINX_VERSION) $(NGINX_IMAGE):$(UBUNTU_VERSION).$(NGINX_VERSION)
up:
	@docker-compose up -d
down:
	@docker-compose down
exec-nginx:
	@docker exec -it con-$(NGINX_IMAGE) bash
exec-httpd:
	@docker exec -it con-$(HTTPD_IMAGE) bash
exec-as-root:
	@docker exec -it con-$(FPM_IMAGE) bash
exec-as-user:
	@docker exec -u $(OWN_USER) -it con-$(FPM_IMAGE) bash
fpm-status:
	@./utils/test-php-fpm.sh  $(FPMIP) status status
fpm-exec-index:
	@./utils/test-php-fpm.sh $(FPMIP) index.php /var/www/main/index.php
check-site:
	@docker exec -it con-$(NGINX_IMAGE) /usr/local/bin/test7.sh
