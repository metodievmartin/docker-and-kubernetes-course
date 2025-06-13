# Docker Multi-Container Application Example

This project demonstrates how to create and connect multiple Docker containers to build a simple web application. The example consists of a MongoDB database, a Node.js REST API backend, and a React frontend, all running in separate containers.

## Project Overview

This application allows users to:
1. Create and manage a list of goals/tasks
2. Store goals persistently in a MongoDB database
3. View and delete goals through a React UI

## Docker Multi-Container Concepts Demonstrated

This project showcases several key Docker concepts:

### 1. Container Orchestration
- Running multiple containers that work together
- Setting up proper networking between containers
- Managing container dependencies

### 2. Data Persistence
- MongoDB data persistence using volumes
- Node.js logs persistence using volumes
- Source code binding for live development

### 3. Container Communication
- Container-to-container communication via Docker networks
- Frontend-to-backend communication via exposed ports

## Docker Commands

### Step 1: Create a Docker Network

```bash
docker network create goals-network
```

**Command Breakdown:**
- `docker network create`: Command to create a new Docker network
- `goals-network`: Name of the network for container communication

### Step 2: Start MongoDB Container

```bash
docker run --name mongodb-container \
  -v data:/data/db \
  --rm -d \
  --network goals-network \
  -e MONGO_INITDB_ROOT_USERNAME=martin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  mongo:5
```

**Command Breakdown:**
- `docker run`: Create and start a container
- `--name mongodb-container`: Name the container for easy reference
- `-v data:/data/db`: Create a named volume "data" mapped to MongoDB's data directory
  - This persists database data even if the container is removed
- `--rm`: Automatically remove the container when it stops
- `-d`: Run in detached mode (background)
- `--network goals-network`: Connect to our custom network
- `-e MONGO_INITDB_ROOT_USERNAME=martin`: Set MongoDB root username
- `-e MONGO_INITDB_ROOT_PASSWORD=secret`: Set MongoDB root password
- `mongo:5`: Use MongoDB version 5 image

### Step 3: Build and Start the Backend Container

```bash
# Navigate to the backend directory
cd /Users/path/to/project/04_multi_container/backend

# Build the image
docker build -t goals-backend-image .

# Run the container
docker run --name goals-backend \
  -v /Users/path/to/project/04_multi_container/backend:/app \
  -v logs:/app/logs \
  -v /app/node_modules \
  -e MONGODB_USERNAME=martin \
  -e MONGODB_PASSWORD=secret \
  --rm -d \
  -p 8080:8080 \
  --network goals-network \
  goals-backend-image
```

**Command Breakdown:**
- `cd /Users/.../backend`: Navigate to the backend directory
- `docker build -t goals-backend-image .`: Build the backend image
  - `-t goals-backend-image`: Tag (name) the image

**Container Run Breakdown:**
- `docker run`: Create and start a container
- `--name goals-backend`: Name the container
- `-v /Users/.../backend:/app`: Bind mount for source code
  - Maps local backend directory to /app in the container
  - Enables live code updates without rebuilding
- `-v logs:/app/logs`: Named volume for logs persistence
  - Stores logs even if the container is removed
- `-v /app/node_modules`: Anonymous volume for node_modules
  - Prevents the bind mount from overwriting container's node_modules
- `-e MONGODB_USERNAME=martin`: Set MongoDB username as environment variable
- `-e MONGODB_PASSWORD=secret`: Set MongoDB password as environment variable
- `--rm`: Automatically remove the container when it stops
- `-d`: Run in detached mode (background)
- `-p 8080:8080`: Map port 8080 on host to port 8080 in container
- `--network goals-network`: Connect to the same network as MongoDB
- `goals-backend-image`: The image to use

### Step 4: Build and Start the Frontend Container

```bash
# Navigate to the frontend directory
cd /Users/path/to/project/04_multi_container/frontend

# Build the image
docker build -t goals-frontend-image .

# Run the container
docker run --name goals-frontend \
  -v /Users/path/to/project/04_multi_container/frontend/src:/app/src \
  --rm -it \
  -p 3001:3000 \
  goals-frontend-image
```

**Command Breakdown:**
- `cd /Users/.../frontend`: Navigate to the frontend directory
- `docker build -t goals-frontend-image .`: Build the frontend image
  - `-t goals-frontend-image`: Tag (name) the image

**Container Run Breakdown:**
- `docker run`: Create and start a container
- `--name goals-frontend`: Name the container
- `-v /Users/.../frontend/src:/app/src`: Bind mount for source code
  - Maps local src directory to /app/src in the container
  - Enables live code updates without rebuilding
- `--rm`: Automatically remove the container when it stops
- `-it`: Run in interactive mode with a terminal
- `-p 3001:3000`: Map port 3001 on host to port 3000 in container
- `goals-frontend-image`: The image to use

## Understanding Container Communication

In this project, containers communicate in two ways:

1. **Container-to-Container Communication**
   - The Node.js backend connects to MongoDB using the container name:
   ```javascript
   mongoose.connect(
     `mongodb://${process.env.MONGODB_USERNAME}:${process.env.MONGODB_PASSWORD}@mongodb-container:27017/course-goals?authSource=admin`,
     ...
   )
   ```
   - This works because both containers are in the same Docker network

2. **Frontend-to-Backend Communication**
   - The React frontend makes requests to the backend:
   ```javascript
   fetch('http://localhost:8080/goals')
   ```
   - **Important Note**: Even though the React app runs in a container, it makes requests to `localhost:8080`. This is because React code is executed in the browser (on the host machine), not in the container itself.

## Data Persistence

This project uses several strategies for data persistence:

1. **MongoDB Data**
   - Uses a named volume: `-v data:/data/db`
   - Persists database data even if the container is removed

2. **Backend Logs**
   - Uses a named volume: `-v logs:/app/logs`
   - Persists application logs even if the container is removed

3. **Source Code**
   - Uses bind mounts for both frontend and backend
   - Enables live code updates without rebuilding containers

## Development Workflow

1. Create a Docker network for container communication
2. Start the MongoDB container in this network
3. Build and run the backend container in the same network
4. Build and run the frontend container
5. Access the application at http://localhost:3001
6. Make changes to the source code and see them reflected immediately

## Common Issues and Solutions

### Backend Can't Connect to MongoDB
- Ensure both containers are in the same network
- Verify MongoDB credentials in environment variables
- Check if MongoDB container is running

### Frontend Can't Connect to Backend
- Ensure backend container is exposing port 8080
- Check if backend is running and responding to requests
- Remember that React runs in the browser, not in the container

### Container Startup Failures
- Check container logs: `docker logs container_name`
- Verify volume paths and permissions
- Ensure required environment variables are set

## Next Steps

- Create a Docker Compose configuration for easier startup
- Add environment-specific configurations
- Implement container health checks
- Consider implementing container orchestration with Kubernetes
