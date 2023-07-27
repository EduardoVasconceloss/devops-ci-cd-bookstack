FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.18

# setando as versões
ARG BUILD_DATE
ARG VERSION
ARG BOOKSTACK_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="homerr"

# versão dos pacotes
ARG BOOKSTACK_RELEASE

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    fontconfig \
    mariadb-client \
    memcached \
    php82-dom \
    php82-gd \
    php82-ldap \
    php82-mysqlnd \
    php82-pdo_mysql \
    php82-pecl-memcached \
    php82-tokenizer \
    qt5-qtbase \
    ttf-freefont && \
  echo "**** configure php-fpm to pass env vars ****" && \
  sed -E -i 's/^;?clear_env ?=.*$/clear_env = no/g' /etc/php82/php-fpm.d/www.conf && \
  grep -qxF 'clear_env = no' /etc/php82/php-fpm.d/www.conf || echo 'clear_env = no' >> /etc/php82/php-fpm.d/www.conf && \
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php82/php-fpm.conf && \
  echo "**** fetch bookstack ****" && \
  mkdir -p\
    /app/www && \
  if [ -z ${BOOKSTACK_RELEASE+x} ]; then \
    BOOKSTACK_RELEASE=$(curl -sX GET "https://api.github.com/repos/bookstackapp/bookstack/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/bookstack.tar.gz -L \
    "https://github.com/BookStackApp/BookStack/archive/${BOOKSTACK_RELEASE}.tar.gz" && \
  tar xf \
    /tmp/bookstack.tar.gz -C \
    /app/www/ --strip-components=1 && \
  echo "**** install composer dependencies ****" && \
  composer install -d /app/www/ && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    $HOME/.cache \
    $HOME/.composer

# copiando os arquivos locais
COPY root/ /

# portas e volumes
EXPOSE 80 443
VOLUME /config