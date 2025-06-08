# Node.js Docker Example

This is a simple Node.js application containerized with Docker.

## Docker Instructions

### Navigating to the Project Folder

First, navigate to the project folder:

```bash
cd /images_and_containers/node_example
```

### Building the Docker Image

To build the Docker image from the Dockerfile, run the following command in this directory:

```bash
docker build -t node-app .
```

This command builds a Docker image with the tag `node-app` using the Dockerfile in the current directory (`.`).

### Understanding Docker Layers and Build Optimization

Docker builds images using a layered approach, where each instruction in the Dockerfile creates a new layer:

#### What are Docker Layers?

1. Each layer represents a change to the filesystem
2. Layers are cached and reused in subsequent builds
3. When a layer changes, all downstream layers must be rebuilt

#### Our Dockerfile Optimization

Notice how our Dockerfile is structured for efficiency:

```dockerfile
# First, copy only package.json
COPY package.json /app

# Then install dependencies
RUN npm install

# Finally, copy the rest of the code
COPY . /app
```

This structure provides significant benefits:

1. **Caching Dependencies**: If `package.json` doesn't change, Docker reuses the cached npm install layer
2. **Faster Rebuilds**: When you only change application code (not dependencies), Docker doesn't reinstall all node modules
3. **Time Savings**: For large projects, this can save minutes on each build

#### How the Optimization Works

1. Docker checks if `package.json` has changed since the last build
   - If unchanged: Use cached layer
   - If changed: Create new layer and continue

2. Same process for `npm install` - only runs if the previous layer changed

3. Application code changes only affect the final `COPY . /app` layer, leaving the dependency installation layer intact

This is why the order of commands in a Dockerfile matters significantly for build performance.

### Running the Docker Container

To run the container from the image and map port 3001 on your host machine to port 80 in the container:

```bash
docker run -p 3001:80 node-app
```

This command:
- `-p 3001:80`: Maps port 3001 on your host machine to port 80 inside the container
- `node-app`: Specifies the image to run

**Note about EXPOSE vs -p**:
The `EXPOSE 80` instruction in the Dockerfile is optional and serves as documentation that the application inside the container uses port 80. However, you still need to use the `-p` flag when running the container to actually map a port on your host machine to the container's port.

### Running in Detached Mode

To run the container in the background (detached mode):

```bash
docker run -d -p 3001:80 node-app
```

The `-d` flag runs the container in detached mode.

### Understanding Docker Images and Code Changes

#### Docker Images are Read-Only

Docker images are **immutable** (read-only). When you build an image, Docker takes a snapshot of your code at that moment and packages it into the image. This means:

1. Any changes you make to your source code **after** building the image will not be reflected in containers running from that image
2. The image serves as a fixed, reproducible template for creating containers

#### Workflow for Making Code Changes

When you modify your code, you need to follow these steps to see the changes in your Docker container:

1. Make changes to your source code
2. Rebuild the image:
   ```bash
   docker build -t node-app .
   ```
3. Stop any running containers using the old image:
   ```bash
   docker stop <container_id>
   ```
4. Start a new container using the freshly built image:
   ```bash
   docker run -p 3001:80 node-app
   ```

#### Why This Is By Design

This immutability is a fundamental feature of Docker that provides several benefits:

- **Consistency**: Ensures the same code runs across all environments
- **Versioning**: Each build creates a distinct, versioned snapshot of your application
- **Security**: Prevents runtime modifications to the application code
- **Reproducibility**: Makes it possible to roll back to previous versions reliably

For development workflows where you need to see code changes immediately, consider using Docker volumes to mount your local code directory into the container (covered in advanced Docker topics).

### Viewing Running Containers

To see all running containers:

```bash
docker ps
```

### Stopping the Container

To stop a running container:

```bash
docker stop <container_id>
```

**Tip about Container IDs**: 
You don't need to type the entire container ID. You can use just the first few characters, enough to uniquely identify the container. For example:

```bash
# If the container ID is abc123def456
docker stop abc
```

This works as long as no other container ID starts with the same characters.

### Removing a Container

To remove a stopped container:

```bash
docker rm <container_id>
```

### Removing the Image

To remove the Docker image:

```bash
docker rmi node-app
```

or by image ID:

```bash
docker rmi <image_id>
```

## Accessing the Application

Once the container is running, you can access the application by opening a web browser and navigating to:

```
http://localhost:3001
