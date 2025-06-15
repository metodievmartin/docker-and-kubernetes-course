# Utility Containers

This section demonstrates the concept of utility containers - 
a Docker pattern for executing specific commands or tasks in isolated environments without installing tools locally.

## What are Utility Containers?

Utility containers are Docker containers that:
- Provide a specific tool or runtime environment (like Node.js)
- Are designed for running commands rather than long-running applications
- Allow you to use tools without installing them on your host machine
- Execute short-lived tasks with predictable environments

## Project Overview

This example creates an NPM utility container that allows you to run NPM commands without having NPM installed locally. This is useful for:

- Development environments where you don't want to install Node.js
- CI/CD pipelines that need to run NPM commands
- Ensuring consistent NPM behavior across different machines
- Isolating NPM dependencies from your host system

## How It Works

### The Dockerfile

```dockerfile
FROM node:14-alpine

WORKDIR /app

ENTRYPOINT [ "npm" ]
```

This Dockerfile:
1. Uses the lightweight Node.js Alpine image
2. Sets the working directory to `/app`
3. Configures `npm` as the entrypoint, meaning any command passed to the container will be executed as `npm <command>`

### The Docker Compose File

```yaml
services:
  npm-util:
    build: ./
    stdin_open: true
    tty: true
    volumes:
      - ./:/app
```

This docker-compose.yaml:
1. Defines an `npm-util` service built from the local Dockerfile
2. Enables interactive mode with `stdin_open` and `tty`
3. Mounts the current directory to `/app` in the container, allowing the container to access your project files

## Running NPM Commands

First, navigate to the utility containers project directory:

```bash
cd path/to/project/06_utility_containers
```

### Using Docker Directly

```bash
# Initialize a new Node.js project
docker run --rm -v $(pwd):/app -it npm-util init

# Install dependencies
docker run --rm -v $(pwd):/app -it npm-util install express

# Run scripts
docker run --rm -v $(pwd):/app -it npm-util run test
```

### Using Docker Compose

```bash
# Initialize a new Node.js project
docker-compose run --rm npm-util init

# Install dependencies
docker-compose run --rm npm-util install express

# Run scripts
docker-compose run --rm npm-util run test
```

## Key Concepts Demonstrated

### ENTRYPOINT vs CMD

- `ENTRYPOINT` defines the executable that always runs when the container starts
- Any arguments passed to `docker run` are appended to the entrypoint command
- This allows for flexible command execution while maintaining a consistent base command

### Volume Mounting

- The project directory is mounted to `/app` in the container
- This allows the container to read and write files in your project
- Changes made by NPM (like creating node_modules or package.json) persist on your host

### Interactive Mode

- `stdin_open: true` and `tty: true` (or `-it` in Docker CLI) enable interactive commands
- This is necessary for commands that require user input, like `npm init`

## Benefits of This Approach

1. **Isolation**: NPM operations don't affect your host system
2. **Consistency**: Everyone on the team gets the same NPM behavior
3. **No Installation**: No need to install Node.js or NPM locally
4. **Version Control**: Easy to switch between different Node.js versions by changing the base image

## Notes on File Permissions

When using utility containers, be aware that:
- Files created by the container may be owned by root or a different user
- This can cause permission issues when accessing these files from the host
- Consider using the `--user` flag with Docker to match your host user ID
