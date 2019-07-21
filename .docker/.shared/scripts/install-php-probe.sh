#!/usr/bin/env bash

version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/$current_os/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=$BLACKFIRE_SOCKET\nblackfire.log_level=$BLACKFIRE_LOG_LEVEL\nblackfire.log_file=/tmp/blackfire.log\nblackfire.agent_timeout=10\nblackfire.apm_enabled=1\nblackfire.server_id=5f72b87b-f435-46fd-ae1b-c7f15410dd31\nblackfire.server_token=6a610b675de20a239cccca13499d4c95a5601401d21c8a656f2f24a7fbc2498d\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

# Please note that the Blackfire Probe is dependent on the session module.
# If it isn't present in your install, you will need # to enable it yourself.
