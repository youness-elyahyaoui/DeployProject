FROM deltasquare4/docker-php-base:latest

MAINTAINER Rakshit Menpara <rakshit@improwised.com>

# Set working directory
WORKDIR /var/www

# Copy Composer files
COPY ./app/composer.* ./

# Install Composer dependencies
RUN composer install \
  --no-scripts \
  --no-autoloader \
  --no-dev

# Copy the rest of the application
COPY ./app ./

# Add build dependencies to compile drafter
RUN set -ex \
  && composer dump-autoload --optimize \
  && chown -R nginx:nginx /var/www

EXPOSE 80
