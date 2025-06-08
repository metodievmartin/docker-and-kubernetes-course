# Base Image
# ------------------------------
# FROM specifies the parent/base image to use as a starting point for this Docker image
# 'node' pulls the latest official Node.js image from Docker Hub which includes Node.js and npm
FROM node

# Working Directory
# ------------------------------
# WORKDIR sets the working directory inside the container
# All subsequent commands (RUN, COPY, CMD) will be executed in this directory
# This creates the directory if it doesn't exist
# Note: '/app' is an arbitrary name - you could use any name like '/myproject', '/code', etc.
# It's a convention in Docker to use '/app' but has no special meaning in Docker or Linux
# This is an absolute path within the container's filesystem, not on your host machine
WORKDIR /app

# Copy Package.json First (Layer Optimization)
# ------------------------------
# By copying only package.json first (not the entire codebase),
# we create a separate Docker layer for dependencies
# This is a key optimization: Docker caches layers, so if package.json doesn't change,
# this layer and the npm install layer below will be reused from cache in future builds
COPY package.json /app

# Install Dependencies
# ------------------------------
# RUN executes commands during the image build process
# This command installs all dependencies defined in package.json
# The installed node_modules will be part of the image
# This layer will only be rebuilt if package.json changes
RUN npm install

# Copy Files
# ------------------------------
# COPY copies files/directories from the host machine to the container
# Syntax: COPY <source> <destination>
# The '.' means copy everything from the current directory on host
# '/app' is the destination inside the container (using the WORKDIR we set)
# This happens AFTER npm install, so changes to your source code won't trigger
# a reinstall of dependencies - significantly speeding up rebuilds
COPY . /app

# Expose Port
# ------------------------------
# EXPOSE informs Docker that the container will listen on the specified port at runtime
# This is a documentation feature and doesn't actually publish the port
# You still need to use -p flag when running the container to publish the port
EXPOSE 80

# Default Command
# ------------------------------
# CMD defines the command that will be executed when the container starts
# Using JSON array format: ["executable", "param1", "param2"]
# This starts the Node.js application by running 'node server.js'
# Only one CMD instruction is allowed per Dockerfile
CMD ["node", "server.js"]