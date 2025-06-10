# Base Image
# ------------------------------
# FROM specifies the parent/base image to use as a starting point for this Docker image
# 'node:14' pulls the official Node.js v14 image from Docker Hub
# Using a specific version (14) instead of 'latest' ensures build consistency over time
FROM node:14

# Working Directory
# ------------------------------
# WORKDIR sets the working directory inside the container
# All subsequent commands (RUN, COPY, CMD) will be executed in this directory
# This creates the directory if it doesn't exist
WORKDIR /app

# Copy Package.json First (Layer Optimization)
# ------------------------------
# By copying only package.json first (not the entire codebase),
# we create a separate Docker layer for dependencies
# This is a key optimization: Docker caches layers, so if package.json doesn't change,
# this layer and the npm install layer below will be reused from cache in future builds
COPY package.json .

# Install Dependencies
# ------------------------------
# RUN executes commands during the image build process
# This command installs all dependencies defined in package.json
# The installed node_modules will be part of the image
# This layer will only be rebuilt if package.json changes
RUN npm install

# Copy Application Files
# ------------------------------
# COPY copies files/directories from the host machine to the container
# The '.' means copy everything from the current directory on host
# The second '.' means copy to the current working directory in the container (/app)
# This happens AFTER npm install, so changes to your source code won't trigger
# a reinstall of dependencies - significantly speeding up rebuilds
# Note: .dockerignore file prevents copying unnecessary files
COPY . .

# Build Arguments
# ------------------------------
# ARG defines a build-time variable that users can pass during image build
# Format: docker build --build-arg DEFAULT_PORT=8000 -t image-name .
# Build arguments are only available during the build process, not in the running container
# Here we set a default port value that can be overridden during build
ARG DEFAULT_PORT=80

# Environment Variables
# ------------------------------
# ENV sets environment variables that will be available to the application at runtime
# Here we set PORT to the value of DEFAULT_PORT build argument
# This makes the build-time argument available at runtime through an environment variable
# The application can access this through process.env.PORT in Node.js
ENV PORT=$DEFAULT_PORT

# Expose Port
# ------------------------------
# EXPOSE informs Docker that the container will listen on the specified port at runtime
# This is a documentation feature and doesn't actually publish the port
# You still need to use -p flag when running the container to publish the port
# Using $PORT variable makes the exposed port configurable through build arguments
EXPOSE $PORT

# Volume Configuration (Commented Out)
# ------------------------------
# VOLUME instruction creates a mount point with the specified name
# This would be used to persist data or share data between containers
# Currently commented out - if uncommented, it would create a volume for node_modules
# This can be useful to prevent overwriting modules when mounting source code from host
# VOLUME [ "/app/node_module" ]

# Default Command
# ------------------------------
# CMD defines the command that will be executed when the container starts
# Using JSON array format: ["executable", "param1", "param2"]
# This starts the Node.js application using the npm start script defined in package.json
# Only one CMD instruction is allowed per Dockerfile
CMD ["npm", "start"]