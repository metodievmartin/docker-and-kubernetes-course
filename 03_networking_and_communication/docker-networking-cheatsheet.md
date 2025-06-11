# Docker Networking & Requests Cheat Sheet

## Networks / Requests

In most real-world applications, multiple containers are used together. This is mainly because:

1. Each container should ideally focus on **one main task** (e.g. web server, database).
2. It is complex and error-prone to configure a single container to do multiple unrelated tasks.

Thus, multi-container setups are common and often require communication:

* **Between containers**
* **With the host machine**
* **With external services on the web**

## 🌍 Communicating with the World Wide Web (WWW)

This is the simplest case. Containers can send HTTP or other requests to the web with no special setup.

Example (JavaScript):

```javascript
fetch('https://some-api.com/my-data').then(...);
```

This works out-of-the-box inside any container.

## 🖥️ Communicating with the Host Machine

Accessing services on the **host machine** (e.g. a database) requires one small change.

### ❌ This won't work from inside a container:

```javascript
fetch('http://localhost:3000/demo').then(...);
```

Inside the container, `localhost` refers to the container itself, **not the host machine**.

### ✅ Use Docker's internal host resolution:

```javascript
fetch('http://host.docker.internal:3000/demo').then(...);
```

`host.docker.internal` is a special DNS name resolved to the host’s IP address by Docker.

## 🔁 Communicating with Other Containers

There are two ways containers can talk to each other:

### ❌ Option 1: Use Container IPs

Not ideal – IPs can change and must be retrieved manually.

### ✅ Option 2: Use a Docker Network

Best practice is to connect containers via a custom Docker network:

```bash
docker network create my-network

docker run --network my-network --name cont1 my-image

docker run --network my-network --name cont2 my-other-image
```

Now containers can refer to each other by **name**:

```javascript
fetch('http://cont1/my-data').then(...);
```

Docker handles the internal DNS resolution automatically.

## 🧠 Additional Networking Commands & Concepts

### 🔍 Inspecting Networks

```bash
docker network ls
# List all Docker networks

docker network inspect my-network
# Inspect network details and connected containers
```

### 🌉 Built-in Network Drivers

* **bridge** (default): Isolated container network using NAT.
* **host**: Container shares host's network stack (Linux only).
* **none**: Disables networking entirely.

```bash
docker run --network host nginx
# Uses host’s network stack (no isolation)
```

### 🧩 Docker Compose Networking

Docker Compose automatically creates a default network:

```yaml
version: '3'
services:
  backend:
    image: my-backend
  frontend:
    image: my-frontend
    depends_on:
      - backend
```

Service names become DNS-resolvable inside the network (`frontend` can reach `backend`).

### 🚪 Expose vs Publish Ports

* `EXPOSE` (Dockerfile): Declares intent, does not expose externally
* `-p` (CLI): Actually maps container port to host port

```bash
docker run -p 3000:3000 my-app
# Makes container’s port 3000 available on host port 3000
```

### 🔐 Isolating Networks for Security

Isolate containers by creating separate networks:

```bash
docker network create --driver bridge isolated_net
```

This prevents cross-talk between unrelated containers by default.

## Summary

| Goal                     | Approach                            |
| ------------------------ | ----------------------------------- |
| Talk to the web          | Works by default                    |
| Talk to host machine     | Use `host.docker.internal`          |
| Talk to other containers | Use a shared Docker network + names |


**Covered Topics:**

* Communicating with the WWW
* Communicating with the Host
* Inter-container Networking with Docker
* Inspecting and Managing Networks
* Docker Compose and Port Publishing
* Network Isolation Best Practices
