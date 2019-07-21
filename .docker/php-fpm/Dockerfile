ARG TARGET_PHP_VERSION=7.3
FROM php:${TARGET_PHP_VERSION}-fpm

# If you use Alpine, you need to set this value to "alpine"
ENV current_os=linux

ARG BLACKFIRE_SERVER_ID
ARG BLACKFIRE_SERVER_TOKEN
ARG BLACKFIRE_CLIENT_ID
ARG BLACKFIRE_CLIENT_TOKEN
ARG BLACKFIRE_LOG_LEVEL
ARG BLACKFIRE_SOCKET
ARG BLACKFIRE_PORT

ENV BLACKFIRE_SOCKET ${BLACKFIRE_SOCKET}
ENV BLACKFIRE_PORT ${BLACKFIRE_PORT}

ARG SERVICE_DIR="./php-fpm"
COPY ./.shared/scripts/ /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

# set timezone
ARG TZ=UTC
RUN /tmp/scripts/set_timezone.sh ${TZ}

# add users
ARG APP_USER=www-data
ARG APP_GROUP=www-data
ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000

RUN /tmp/scripts/create_user.sh ${APP_USER} ${APP_GROUP} ${APP_USER_ID} ${APP_GROUP_ID}

#RUN /tmp/scripts/install-php-dependencies.sh

# RUN /tmp/scripts/install_php_extensions.sh

# RUN /tmp/scripts/install_software.sh

RUN /tmp/scripts/install-php-probe.sh

RUN mkdir -p /tmp/blackfire \
    && curl -A "Docker" -L https://blackfire.io/api/v1/releases/client/linux_static/amd64 | tar zxp -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire /usr/bin/blackfire \
    && rm -Rf /tmp/blackfire

# php config
COPY ./.shared/config/php/conf.d/*  /usr/local/etc/php/conf.d/

# php-fpm pool config
COPY ${SERVICE_DIR}/php-fpm.d/* /usr/local/etc/php-fpm.d
RUN /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/zz-app.conf \
    "__APP_USER" \
    "${APP_USER}" \
 && /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/zz-app.conf \
    "__APP_GROUP" \
    "${APP_GROUP}" \
;

# workdir
ARG APP_CODE_PATH="/var/www/current"
WORKDIR "$APP_CODE_PATH"

# Blackfire extension setup
#RUN docker-php-ext-enable blackfire

# entrypoint
RUN mkdir -p /bin/docker-entrypoint/ \
 && cp /tmp/scripts/docker-entrypoint/* /bin/docker-entrypoint/ \
 && chmod +x -R /bin/docker-entrypoint/ \
;

RUN /tmp/scripts/cleanup.sh
ENTRYPOINT ["/bin/docker-entrypoint/resolve-docker-host-ip.sh","php-fpm"]
EXPOSE 9000

