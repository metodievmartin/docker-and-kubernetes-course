# Docker Data & Volumes Example

This project demonstrates how to manage data persistence in Docker containers using volumes and bind mounts. It's a Node.js feedback application that stores user feedback as text files.

## Project Overview

This is a simple web application that:
1. Allows users to submit feedback via a web form
2. Stores the feedback as text files in a `/feedback` directory
3. Uses temporary files in a `/temp` directory during processing

## Docker Data Concepts Demonstrated

This project showcases three key Docker data persistence concepts:

### 1. Named Volumes

Named volumes are managed by Docker and persist data even when containers are removed.
- Example: The `feedback` volume in our project stores user feedback files

### 2. Bind Mounts

Bind mounts map a host directory to a container directory, allowing real-time code changes.
- Example: Mapping our project directory to `/app` in the container

### 3. Anonymous Volumes

Anonymous volumes are temporary volumes with no specific name.
- Example: The `/app/node_modules` and `/app/temp` volumes in our project

### 4. Build Arguments & Environment Variables

The project also demonstrates how to use build arguments and environment variables:
- Build arguments (`ARG`) allow customization during image build time
- Environment variables (`ENV`) make these values available at runtime
- Example: Configuring the application port through `DEFAULT_PORT` build argument

## Docker Commands

### Building the Image

Basic build:
```bash 
docker build -t feedback-node .
```

Build with custom port:
```bash
docker build -t feedback-node --build-arg DEFAULT_PORT=8000 .
```

**Command Breakdown:**
- `docker build`: Command to build a Docker image
- `-t feedback-node`: Tag (name) the image as "feedback-node"
- `--build-arg DEFAULT_PORT=8000`: Override the default port value (80)
- `.`: Use the Dockerfile in the current directory

### Running the Container with Volumes

```bash
docker run -d -p 3001:80 \
  --name feedback-app \
  --rm \
  -v feedback:/app/feedback \
  -v /Users/current_user/path/to/project:/app:ro \
  -v /app/node_modules \
  -v /app/temp \
  feedback-node
```

**Command Breakdown:**

#### Basic Container Configuration
- `docker run`: Command to create and start a container
- `-d`: Run in detached mode (background)
- `-p 3001:80`: Map port 3001 on host to port 80 in container
- `--name feedback-app`: Name the container "feedback-app"
- `--rm`: Automatically remove the container when it stops

#### Volume Configuration
- `-v feedback:/app/feedback`: Create a named volume "feedback" mapped to /app/feedback in container
  - This persists feedback data even if container is removed
  
- `-v /Users/.../project:/app:ro`: Bind mount (maps host directory to container)
  - Maps your local project directory to /app in the container
  - Should use an absolute path or this `$(pwd)` shortcut
  - `:ro` makes it read-only in the container for safety
  - Allows real-time code changes without rebuilding the image
  
- `-v /app/node_modules`: Anonymous volume for node_modules
  - Prevents the bind mount from overwriting the container's node_modules
  - Ensures the container uses the modules installed during image build
  
- `-v /app/temp`: Anonymous volume for the temp directory
  - Prevents the read-only bind mount from blocking write operations to temp

- `feedback-node`: The image to use for this container

## Understanding Docker Volumes

### Named Volumes
- Managed by Docker
- Persist beyond container lifecycle
- Not easily accessible from host machine
- Ideal for: Database files, user-generated content

### Bind Mounts
- Maps host directory to container directory
- Changes reflect immediately in both directions
- Easily accessible from host machine
- Ideal for: Development with live code changes

### Anonymous Volumes
- Managed by Docker
- Removed when container is removed (if --rm is used)
- Used to protect specific directories from being overwritten
- Ideal for: Temporary data, protecting specific directories

## Understanding Build Arguments & Environment Variables

### Build Arguments (ARG)
- Defined with `ARG` in Dockerfile
- Values can be provided during build with `--build-arg`
- Only available during image build, not in running containers
- Useful for: Configuring build-time settings

### Environment Variables (ENV)
- Defined with `ENV` in Dockerfile
- Available at runtime to the application
- Can be set from build arguments to make build-time values available at runtime
- Can be overridden when starting a container with `-e` or `--env`
- Useful for: Runtime configuration, passing secrets

### Example in this Project
Our Dockerfile uses:
```dockerfile
ARG DEFAULT_PORT=80
ENV PORT=$DEFAULT_PORT
EXPOSE $PORT
```

This allows:
1. Setting a default port (80)
2. Overriding it during build: `docker build --build-arg DEFAULT_PORT=8000 -t feedback-node .`
3. The application can access this value via `process.env.PORT` in Node.js

## Common Volume Commands

List all Docker volumes:
```bash
docker volume ls
```

Create a volume:
```bash
docker volume create [VOLUME_NAME]
```

Remove a volume:
```bash
docker volume rm [VOLUME_NAME]
```

Remove all unused volumes:
```bash
docker volume prune
```

## Using the Application

1. Build the image: 
    ```bash 
    docker build -t feedback-node .
    ```
2. Start the container with volumes:
   ```bash
   docker run -d -p 3001:80 \
     --name feedback-app \
     --rm \
     -v feedback:/app/feedback \
     -v $(pwd):/app:ro \
     -v /app/node_modules \
     -v /app/temp \
     feedback-node
   ```
3. Access the application at: http://localhost:3001
4. Submit feedback via the web form
5. Feedback will be stored in the Docker volume and persist even if the container is removed

## Development Workflow

1. Make changes to the source code on your host machine
2. Changes are immediately reflected in the container (no rebuild needed)
3. If you change package.json, you will need to rebuild the image to install new dependencies

## Notes on Read-Only Bind Mounts

The `:ro` flag in `-v /path/to/project:/app:ro` makes the bind mount read-only in the container. This is a security best practice that prevents container processes from modifying host files.

However, this creates a challenge for directories that need write access (like `/app/temp` and `/app/feedback`). We solve this by:

1. Using a named volume for `/app/feedback` to make it writable and persistent
2. Using an anonymous volume for `/app/temp` to make it writable but temporary
3. Using an anonymous volume for `/app/node_modules` to prevent it from being overwritten by the bind mount

This configuration gives us the best of both worlds: security of read-only access with targeted write permissions where needed.
