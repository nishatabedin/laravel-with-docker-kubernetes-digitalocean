FROM php:8.2-fpm

WORKDIR /var/www/html

RUN apt-get update && apt-get upgrade -y \
  && apt-get install --quiet --yes --no-install-recommends \
    libzip-dev \
    unzip \
  && docker-php-ext-install mysqli zip pdo pdo_mysql \
  && pecl install -o -f redis \
  && docker-php-ext-enable mysqli redis

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN groupadd --gid 1000 appuser \
  && useradd --uid 1000 -g appuser \
     -G www-data,root --shell /bin/bash \
     --create-home appuser

USER appuser

