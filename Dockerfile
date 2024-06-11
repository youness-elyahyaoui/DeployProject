FROM deltasquare4/docker-php-base:latest

# Set environment variable to allow Composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER=1

# Copy Composer files and install dependencies
COPY ./app/composer.* /var/www/
RUN composer install --no-scripts --no-autoloader --no-dev

# Copy the rest of the application
COPY ./app /var/www

# Ensure bootstrap/cache directory exists and is writable
RUN mkdir -p /var/www/bootstrap/cache && chown -R nginx:nginx /var/www/bootstrap/cache

# Optimize autoload and set permissions
RUN set -ex \
    && composer dump-autoload --optimize \
    && chown -R nginx:nginx /var/www

# Expose the web server port (80)
EXPOSE 3000
