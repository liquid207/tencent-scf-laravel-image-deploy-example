FROM composer:2 as vendor

COPY composer.json composer.json
COPY composer.lock composer.lock

RUN set -x \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && composer install \
      --ignore-platform-reqs \
      --no-interaction \
      --no-plugins \
      --no-scripts \
      --prefer-dist

FROM php:8.0.17-cli-alpine3.15 as builder

COPY . /app
WORKDIR /app
COPY --from=vendor /app/vendor/ /app/vendor/

RUN set -xe \
    && mkdir -p /tmp/storage \
    && chmod -R 770 /tmp/storage

ENTRYPOINT php artisan serve --host 0.0.0.0 --port 9000
