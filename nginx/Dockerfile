ARG UBUNTU_VERSION
FROM dimmsd/ubuntu-base:$UBUNTU_VERSION as builder
MAINTAINER Dimm <tirri@yandex.ru>
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
    build-essential -y \
    wget \
    tar \
    gcc \
    make \
    git \
    libpcre3 \
    libpcre3-dev \
    libssl-dev \
    zlib1g \
    zlib1g-dev \
    libgeoip-dev \
    libxslt1-dev \
    libxml2-dev \
    libgd-dev \
    google-perftools \
    libgoogle-perftools-dev \
    libperl-dev \
    libevent-dev \
    libldap2-dev

WORKDIR /tmp

ARG NGINX_VERSION

RUN wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -O nginx.tar.gz && \
    mkdir /tmp/nginx && \
    tar -xzvf nginx.tar.gz -C /tmp/nginx --strip-components=1 &&\
    git clone https://github.com/kvspb/nginx-auth-ldap.git /tmp/nginx/nginx-auth-ldap

WORKDIR /tmp/nginx

RUN ./configure \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/run/nginx.pid \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --lock-path=/var/lock/nginx.lock \
        --http-client-body-temp-path=/var/lib/nginx/body \
        --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
        --http-proxy-temp-path=/var/lib/nginx/proxy \
        --http-scgi-temp-path=/var/lib/nginx/scgi \
        --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
        --user=www-data \
        --group=www-data \
        --build=Ubuntu \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --with-http_ssl_module \
        --with-http_image_filter_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_gunzip_module \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_sub_module \
        --with-http_stub_status_module \
        --with-http_v2_module \
        --with-http_secure_link_module \
        --with-http_geoip_module \
        --with-http_xslt_module \
        --with-http_secure_link_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-stream \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-pcre \
        --with-pcre-jit \
        --with-file-aio \
        --with-compat \
        --with-threads \
        --with-debug \
        --add-module=nginx-auth-ldap && \
    make
RUN make install

WORKDIR /tmp

RUN git clone https://github.com/perusio/nginx_ensite.git /tmp/nginx_ensite \
    && cd nginx_ensite \
    && make install

ARG UBUNTU_VERSION
FROM dimmsd/ubuntu-base:$UBUNTU_VERSION
LABEL maintainer="tirri@yandex.ru"
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=builder /tmp/nginx /tmp/nginx
COPY --from=builder /usr/local/bin/nginx_ensite /usr/local/bin/nginx_ensite
COPY --from=builder /usr/local/bin/nginx_dissite /usr/local/bin/nginx_dissite

COPY ./utils/* /usr/local/bin/

RUN apt-get update \
    &&  apt-get install --no-install-recommends -y \
    libssl1.1 libxslt1.1 libgd3 libgeoip1 gettext-base libldap2-dev make curl \
    && cd /tmp/nginx \
    && make install \
# create folders
    && mkdir -p /var/log/nginx \
    && mkdir -p /var/lib/nginx \
    && mkdir -p /etc/nginx/conf.d \
    && mkdir -p /etc/nginx/templates \
    && mkdir -p /etc/nginx/sites-available \
    && mkdir -p /etc/nginx/sites-enabled \
    && mkdir -p /etc/nginx/snippets \
    && mkdir -p /var/www/main \
    && mkdir -p /var/www/default \
# reduce image size
    && apt-get purge -y make \
# clean
    && apt-get -y autoremove \
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# rights
    && chmod +x /usr/local/bin/*

COPY ./nginx/conf/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/sites/* /etc/nginx/templates/
COPY ./www/main/* /var/www/main/
COPY ./www/default/* /var/www/default/

EXPOSE 80/tcp 443/tcp

CMD ["/usr/local/bin/nginx-foreground"]

ARG COMMIT
ENV LAST_COMMIT=$COMMIT