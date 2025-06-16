# Use PHP 8.4 with FPM (FastCGI Process Manager) on Alpine Linux
# Alpine provides a minimal footprint for better performance and security
FROM php:8.4-fpm-alpine

# Set the working directory for PHP application files
# This is where PHP-FPM will execute PHP code
WORKDIR /var/www/html

# Copy the source code from the host to the container
# This includes the Laravel application files
COPY src .

# Install PHP extensions required by Laravel
# pdo and pdo_mysql are needed for database connectivity
RUN docker-php-ext-install pdo pdo_mysql

# Set proper ownership of the application files
# www-data is the standard user for PHP-FPM
# This ensures proper permissions for file access
RUN chown -R www-data:www-data /var/www/html

# If we don't specify CMD then the one in the base image will be used