FROM php:7.4-apache

# Install PHP extensions
RUN apt-get update \
    && docker-php-ext-install mysqli

# Copy app code
COPY . /var/www/html/

# Expose the port the app runs on
EXPOSE 80

# Set environment variables for database connection
ENV MYSQL_HOST=mysql-service
ENV MYSQL_PORT=3306
ENV MYSQL_DATABASE=database_name
ENV MYSQL_USER=username
ENV MYSQL_PASSWORD=password