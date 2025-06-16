# Use the latest official Composer image as base
# This provides the Composer PHP dependency management tool pre-installed
FROM composer:latest

# Set the working directory inside the container
# All subsequent commands will run in this directory
WORKDIR /var/www/html

# Set the entrypoint to run composer with --ignore-platform-reqs flag
# This flag tells Composer to ignore platform requirements (like PHP version)
# when installing packages, which is useful in containerized environments
ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]