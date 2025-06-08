# Base Image
# ------------------------------
# FROM specifies the parent/base image to use as a starting point for this Docker image
# 'python' pulls the latest official Python image from Docker Hub which includes Python interpreter and pip
FROM python

# Working Directory
# ------------------------------
# WORKDIR sets the working directory inside the container
# All subsequent commands (RUN, COPY, CMD) will be executed in this directory
# This creates the directory if it doesn't exist
# Note: '/app' is an arbitrary name chosen by the developer, not a special Docker directory
WORKDIR /app

# Copy Files
# ------------------------------
# COPY copies files/directories from the host machine to the container
# Syntax: COPY <source> <destination>
# The '.' means copy everything from the current directory on host
# '/app' is the destination inside the container (using the WORKDIR we set)
COPY . /app

# Default Command
# ------------------------------
# CMD defines the command that will be executed when the container starts
# Using JSON array format: ["executable", "param1", "param2"]
# This starts the Python application by running 'python rng.py'
# Only one CMD instruction is allowed per Dockerfile
CMD ["python", "rng.py"]