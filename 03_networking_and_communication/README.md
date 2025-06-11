# Docker Networking & Communication Example

This project demonstrates how Docker containers can communicate with each other and with external services using Docker networks. The example uses a Node.js application that connects to a MongoDB database to store and retrieve Star Wars favorites.

## Project Overview

This is a simple RESTful API application that:
1. Connects to a MongoDB database container
2. Allows saving favorite Star Wars movies and characters
3. Retrieves data from an external API (Star Wars API)
4. Demonstrates container-to-container communication

## Docker Networking Concepts

### Container Communication Challenges

When working with multiple containers, they need to communicate with each other. There are several approaches:

1. **Using host.docker.internal**
   - Allows containers to access services on the host machine
   - Example: `mongodb://host.docker.internal:27017/swfavorites`
   - Limited to container-to-host communication

2. **Using Container IP Addresses**
   - Each container gets its own IP address
   - Can be found with `docker inspect container_name`
   - Not reliable as IP addresses can change when containers restart

3. **Using Docker Networks (Recommended)**
   - Containers in the same network can communicate using container names
   - Provides DNS resolution between containers
   - More reliable and easier to manage

## Docker Network Commands

### Creating a Network

```bash
# Create a network
docker network create favourites-network
```

### Listing Networks

```bash
# List all networks
docker network ls
```

### Inspecting a Network

```bash
# Get detailed information about a network
docker network inspect favourites-network
```

### Removing a Network

```bash
# Remove a network
docker network rm favourites-network
```

## Running the Application

### Step 1: Create a Docker Network

```bash
docker network create favourites-network
```

### Step 2: Run MongoDB Container in the Network

```bash
docker run -d \
  --name mongodb-container \
  --network favourites-network \
  mongo:5
```

**Command Breakdown:**
- `docker run`: Create and start a container
- `-d`: Run in detached mode (background)
- `--name mongodb-container`: Name the container for easy reference
- `--network favourites-network`: Connect to our custom network
- `mongo:5`: Use MongoDB version 5 image

### Step 3: Build the Node.js Application

```bash
# Navigate to the project directory
cd /03_networking_and_communication

# Build the Docker image
docker build -t favourites-image .
```

**Command Breakdown:**
- `docker build`: Build a Docker image
- `-t favourites-image`: Tag (name) the image
- `.`: Use the Dockerfile in the current directory

### Step 4: Run the Node.js Application Container

```bash
docker run -d --rm \
  --name favourites-app \
  -p 3001:3001 \
  --network favourites-network \
  favourites-image
```

**Command Breakdown:**
- `docker run`: Create and start a container
- `-d`: Run in detached mode (background)
- `--rm`: Automatically remove the container when it stops
- `--name favourites-app`: Name the container
- `-p 3001:3001`: Map port 3001 on host to port 3001 in container
- `--network favourites-network`: Connect to the same network as MongoDB
- `favourites-image`: The image to use

## API Endpoints

The application exposes the following endpoints:

- `GET /favorites`: List all saved favorites
- `POST /favorites`: Save a new favorite
  - Required body: `{ "name": "...", "type": "movie|character", "url": "..." }`
- `GET /movies`: Fetch Star Wars movies from external API
- `GET /people`: Fetch Star Wars characters from external API

## Understanding Container Communication

In this project, containers communicate in two ways:

1. **Container-to-Container Communication**
   - The Node.js app container connects to MongoDB using the container name:
   ```javascript
   mongoose.connect('mongodb://mongodb-container:27017/swfavorites', ...)
   ```
   - This works because both containers are in the same Docker network

2. **Container-to-External Communication**
   - The Node.js app makes HTTP requests to the Star Wars API:
   ```javascript
   axios.get('https://swapi.dev/api/films')
   ```
   - Containers can access the internet by default

## Docker Network Drivers

Docker Networks support different kinds of "Drivers" which influence the behavior of the Network:

### Bridge (Default)
- Used for communication between containers on the same Docker host
- Containers can find each other by name if they are in the same Network
- Created with: `docker network create --driver bridge my-net`
  (or simply `docker network create my-net` since bridge is the default)

### Host
- For standalone containers
- Removes isolation between container and host system (they share localhost)
- Created with: `docker network create --driver host my-net`
- Use case: When you need maximum performance and don't need container isolation

### Overlay
- For communication between containers across multiple Docker hosts
- Only works in "Swarm" mode (a dated/almost deprecated orchestration system)
- Created with: `docker network create --driver overlay my-net`
- Use case: Distributed applications across multiple Docker hosts

### Macvlan
- Allows setting a custom MAC address to a container
- This address can then be used for communication with that container
- Created with: `docker network create --driver macvlan my-net`
- Use case: When containers need to appear as physical devices on your network

### None
- All networking is disabled
- Created with: `docker network create --driver none my-net`
- Use case: When you want to completely isolate a container

### Third-party plugins
- You can install third-party plugins which add various behaviors and functionalities

In most scenarios, the "bridge" driver is the most appropriate choice.

## Common Networking Issues and Solutions

### Container Can't Connect to Another Container
- Ensure both containers are in the same network
- Check if you're using the correct container name
- Verify that the service in the container is running and binding to the correct address

### Container Can't Access External Services
- Verify that the Docker host has internet access
- Check if any firewall is blocking outbound connections
- Ensure DNS resolution is working properly

### Port Conflicts
- If you get "port is already allocated" errors, ensure the host port isn't already in use
- Use a different host port: `-p 3002:3001` (maps host port 3002 to container port 3001)

## Development Workflow

1. Create a Docker network for your application
2. Start your database container in this network
3. Build and run your application container in the same network
4. Make API requests to your application at http://localhost:3001

## Best Practices

1. **Use Custom Networks**: Always create custom networks for your applications instead of using the default bridge network
2. **Use Container Names**: Reference containers by name rather than IP addresses
3. **Separate Concerns**: Run different services in different containers
4. **Port Mapping**: Only expose ports that need to be accessible from outside
5. **Security**: Consider network segmentation for sensitive services
