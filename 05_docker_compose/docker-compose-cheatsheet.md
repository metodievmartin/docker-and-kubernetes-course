# Docker Compose Cheat Sheet

## 🐳 Docker Compose Overview

Docker Compose is a Docker tool for **orchestrating multiple containers** via a single YAML file. It's useful for both multi-container setups and simplifying single container management.

### Why Use Docker Compose?

Without Compose, starting a full app stack means:

```bash
docker network create shop

docker build -t shop-node .
docker run -v logs:/app/logs --network shop --name shop-web shop-node

docker build -t shop-database .
docker run -v data:/data/db --network shop --name shop-db shop-database
```

With Compose:

```bash
docker-compose up
```

All containers are defined and started from a single `docker-compose.yaml` file.

---

## 🧾 Docker Compose File Structure

A simple `docker-compose.yaml` example:

```yaml
version: "3.8"

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile-web
    volumes:
      - logs:/app/logs

  db:
    build:
      context: ./db
      dockerfile: Dockerfile-db
    volumes:
      - data:/data/db

volumes:
  logs:
  data:
```

### Notes:

* The `services` block defines each container.
* `build` can include a path (`context`) and custom Dockerfile.
* `volumes` allow persistent or shared storage.
* Compose automatically creates a shared network.

---

## 🛠️ Key Docker Compose Commands

```bash
docker-compose up
# Start all containers

-d
# Run in detached mode

--build
# Force rebuild of all services
```

```bash
docker-compose down
# Stop and remove all containers

-v
# Remove associated volumes too
```

---

## 🔗 Useful References

* [Compose File Reference](https://docs.docker.com/compose/compose-file/)
* [Compose Command Reference](https://docs.docker.com/compose/reference/)

---

**Topics Covered:**

* Why use Docker Compose
* `docker-compose.yaml` structure
* Key commands and options
* Built-in networking and volume support
