# Docker Compose Example

This project demonstrates how to use Docker Compose to simplify the management of a multi-container application. It builds upon the concepts from the previous multi-container example but uses Docker Compose to orchestrate all containers with a single configuration file.

## Project Overview

This application is the same as the multi-container example and allows users to:
1. Create and manage a list of goals/tasks
2. Store goals persistently in a MongoDB database
3. View and delete goals through a React UI

## Environment Configuration

This project uses environment files to manage configuration and secrets. Before running the application, ensure you have the following files in the `05_docker_compose/env` directory:

### 1. `mongo.env`

This file contains MongoDB authentication credentials:

```
MONGO_INITDB_ROOT_USERNAME=martin
MONGO_INITDB_ROOT_PASSWORD=secret
```

### 2. `backend.env`

This file contains the credentials for the backend to connect to MongoDB:

```
MONGODB_USERNAME=martin
MONGODB_PASSWORD=secret
```

## Running the Application

Follow these steps to run the application:

1. Navigate to the project directory:
   ```bash
   cd path/to/project/05_docker_compose
   ```

2. Ensure the environment files are properly set up in the `env` folder as described above.

3. Start all containers with Docker Compose:
   ```bash
   docker-compose up -d
   ```
   This command starts all services defined in the docker-compose.yaml file in detached mode.

4. Check if all containers are running:
   ```bash
   docker-compose ps
   ```

5. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8080/goals

6. To view logs from all containers:
   ```bash
   docker-compose logs
   ```
   
   Or from a specific service:
   ```bash
   docker-compose logs backend
   ```

7. To stop the application:
   ```bash
   docker-compose down
   ```
   
   To stop and remove volumes (this will delete all data):
   ```bash
   docker-compose down -v
   ```

## Docker Compose Concepts Demonstrated

### 1. Container Orchestration Simplified

Docker Compose allows you to define and run multi-container Docker applications using a single YAML file. Key benefits include:

- **Simplified Container Management**: Start, stop, and rebuild all containers with a single command
- **Declarative Configuration**: Define your entire application stack in one file
- **Built-in Service Discovery**: Containers can reference each other by service name
- **Automatic Network Creation**: No need to manually create Docker networks

### 2. From Multiple Commands to One File

Without Docker Compose, you would need to run multiple commands:

```bash
# Create network
docker network create goals-net

# Run MongoDB container
docker run \
  --name mongodb \
  -e MONGO_INITDB_ROOT_USERNAME=martin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  -v data:/data/db \
  --rm \
  -d \
  --network goals-net \
  mongo

# Build and run backend
docker build -t goals-node ./backend

docker run \
  --name goals-backend \
  -e MONGODB_USERNAME=martin \
  -e MONGODB_PASSWORD=secret \
  -v logs:/app/logs \
  -v ./backend:/app \
  -v /app/node_modules \
  --rm \
  -d \
  --network goals-net \
  -p 8080:80 \
  goals-node

# Build and run frontend
docker build -t goals-react ./frontend

docker run \
  --name goals-frontend \
  -v ./frontend/src:/app/src \
  --rm \
  -d \
  -p 3000:3000 \
  -it \
  goals-react
```

With Docker Compose, you just need:

```bash
docker-compose up
```

## Docker Compose File Explained

The `docker-compose.yaml` file defines all services, networks, and volumes:

```yaml
# Docker Compose file version - historically used to specify the compatibility level
# As of Docker Compose V2, the version field is obsolete and will be ignored
# version: "3.8"

services:
  mongodb:  # MongoDB service definition
    image: 'mongo:5'  # Use the official MongoDB image
    volumes:
      - data:/data/db  # Persist MongoDB data
    env_file:
      - ./env/mongo.env  # Load MongoDB environment variables from file
  
  backend:  # Node.js backend service
    build: ./backend  # Build from Dockerfile in ./backend
    ports:
      - '8080:80'  # Map host port 8080 to container port 80
    volumes:
      - logs:/app/logs  # Persist logs
      - ./backend:/app  # Bind mount for live code updates
      - /app/node_modules  # Anonymous volume to protect node_modules
    env_file:
      - ./env/backend.env  # Load backend environment variables from file
    depends_on:
      - mongodb  # Ensure MongoDB starts first
  
  frontend:  # React frontend service
    build: ./frontend  # Build from Dockerfile in ./frontend
    ports:
      - '3000:3000'  # Map host port 3000 to container port 3000
    volumes:
      - ./frontend/src:/app/src  # Bind mount only the src directory for live code updates
      - /app/node_modules  # Anonymous volume to protect node_modules
    stdin_open: true  # Keep STDIN open (equivalent to -i)
    tty: true  # Allocate a pseudo-TTY (equivalent to -t)
    depends_on:
      - backend  # Ensure backend starts first

volumes:  # Define named volumes
  data:  # For MongoDB data
  logs:  # For application logs
```

### Note on Docker Compose Versioning

In earlier versions of Docker Compose (v1.x), the `version` field was required to specify which Compose file format you were using. With Docker Compose V2 (now the default in recent Docker installations), this field is obsolete and ignored. The Compose specification now automatically detects the appropriate schema version based on the features you're using in your file.

## Key Docker Compose Features Used

### 1. Service Dependencies

```yaml
depends_on:
  - mongodb
```

This ensures services start in the correct order. However, note that `depends_on` only waits for the container to start, not for the service inside to be ready.

### 2. Environment Variables

```yaml
env_file:
  - ./env/mongo.env
```

Environment variables are loaded from external files, making it easier to manage configurations and secrets.

### 3. Volume Definitions

```yaml
volumes:
  - logs:/app/logs  # Named volume
  - ./backend:/app  # Bind mount for backend
  - ./frontend/src:/app/src  # Bind mount only the src directory for frontend
  - /app/node_modules  # Anonymous volume
```

Docker Compose supports all volume types and makes them easier to define.

### 4. Automatic Networking

Services can reference each other by name (e.g., `mongodb` in connection strings) because Docker Compose automatically creates a network and connects all services to it.

## Docker Compose Commands

### Starting the Application

```bash
# Start all services in detached mode
docker-compose up -d

# Force rebuild of images
docker-compose up -d --build
```

### Stopping the Application

```bash
# Stop and remove containers
docker-compose down

# Stop and remove containers + volumes
docker-compose down -v
```

### Viewing Logs

```bash
# View logs from all services
docker-compose logs

# View logs from specific service
docker-compose logs backend
```

### Executing Commands in Containers

```bash
# Run a command in a running container
docker-compose exec backend npm test
```

## Development Workflow

1. Define your services in `docker-compose.yaml`
2. Start all services with `docker-compose up -d`
3. Make changes to your code - they are reflected immediately due to bind mounts
4. View logs with `docker-compose logs`
5. Stop all services with `docker-compose down`

## Benefits Over Manual Docker Commands

1. **Simplicity**: One file instead of multiple commands
2. **Reproducibility**: Environment is defined as code
3. **Maintainability**: Easy to update and version control
4. **Portability**: Works the same on any machine with Docker installed
5. **Service Discovery**: Automatic DNS resolution between containers

## Notes on Container Communication

The backend service can connect to MongoDB using:

```javascript
mongoose.connect(
  `mongodb://${process.env.MONGODB_USERNAME}:${process.env.MONGODB_PASSWORD}@mongodb:27017/course-goals?authSource=admin`,
  ...
)
```

Note that `mongodb` is the service name defined in the Docker Compose file, not a hostname or IP address.
