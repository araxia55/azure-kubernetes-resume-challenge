FROM php:7.4-apache

# Install PHP extensions
RUN apt-get update \
    && docker-php-ext-install mysqli

# Copy app code
COPY . /var/www/html/

# Expose the port the app runs on
EXPOSE 80