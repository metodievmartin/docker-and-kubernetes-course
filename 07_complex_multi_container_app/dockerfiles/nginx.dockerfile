# Use the stable Alpine-based Nginx image as the base
# Alpine provides a minimal footprint while maintaining stability
FROM nginx:stable-alpine

# Set the working directory for Nginx configuration
WORKDIR /etc/nginx/conf.d

# Copy the Nginx configuration file from the host to the container
# This configuration is set up to work with Laravel and PHP-FPM
COPY nginx/nginx.conf .

# Rename the configuration file to default.conf
# This ensures Nginx loads our custom configuration
RUN mv nginx.conf default.conf

# Set the working directory to the web root directory
# This is where Nginx will serve files from
WORKDIR /var/www/html

COPY src .