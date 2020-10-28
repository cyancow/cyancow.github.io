FROM nginx:latest

LABEL version="1.0"
LABEL author="阳明 <icnych@gmail.com>"

# 设置成非交互式的
ENV DEBIAN_FRONTEND noninteractive
ENV DOCUMENT_ROOT /usr/share/nginx/html

# 安装 nginx php-fpm php-pdo unzip curl
RUN apt-get update && apt-get -y install \
    apt-utils \
    curl \
    php-fpm \
    php-sqlite3 \
    unzip

COPY wordpress-5.2.4.tar.gz .

RUN rm -rf ${DOCUMENT_ROOT}/* && \
    tar -xzvf wordpress-5.2.4.tar.gz --strip-components=1 --directory ${DOCUMENT_ROOT} && \
    rm -rf wordpress-5.2.4.tar.gz
# RUN rm -rf ${DOCUMENT_ROOT}/* && \
#     curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
#     tar -xzvf /wordpress.tar.gz --strip-components=1 --directory ${DOCUMENT_ROOT}

COPY sqlite-integration.1.8.1.zip .
RUN unzip sqlite-integration.1.8.1.zip -d ${DOCUMENT_ROOT}/wp-content/plugins/ && \
    rm -rf sqlite-integration.1.8.1.zip
# RUN curl -o sqlite-plugin.zip https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip && \
    # unzip sqlite-plugin.zip -d ${DOCUMENT_ROOT}/wp-content/plugins/ && \
    # rm sqlite-plugin.zip && \

RUN cp ${DOCUMENT_ROOT}/wp-content/plugins/sqlite-integration/db.php ${DOCUMENT_ROOT}/wp-content && \
    cp ${DOCUMENT_ROOT}/wp-config-sample.php ${DOCUMENT_ROOT}/wp-config.php

# nginx 配置
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf \
    && sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 10m/" /etc/nginx/nginx.conf \
    && sed -i -e "s|include /etc/nginx/conf.d/\*.conf|include /etc/nginx/sites-enabled/\*|g" /etc/nginx/nginx.conf \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

# php-fpm 配置
# RUN php --ini  # z找到fpm配置
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.3/fpm/php.ini \
    && sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 10M/g" /etc/php/7.3/fpm/php.ini \
    && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 10M/g" /etc/php/7.3/fpm/php.ini \
    && sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.3/fpm/pool.d/www.conf \
    && sed -i -e "s/;listen.mode = 0660/listen.mode = 0666/g" /etc/php/7.3/fpm/pool.d/www.conf

COPY nginx.conf /etc/nginx/sites-available/default
RUN chown -R www-data.www-data ${DOCUMENT_ROOT} \
    && mkdir -p /etc/nginx/sites-enabled \
    && ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default \
    && apt-get purge -y --auto-remove curl unzip

EXPOSE 80
EXPOSE 443

CMD service php7.3-fpm start && nginx
