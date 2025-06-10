# Docker Data Volumes Cheat Sheet

## Data & Volumes

Docker images are **read-only** – once created, they cannot be changed unless rebuilt.

Containers, however, can read and write. They add a thin "read-write layer" on top of the image, allowing file modifications without changing the original image.

However, two main issues arise in many Docker-based applications:

1. **Data loss on container removal** – All data written in the container is lost when the container is removed.
2. **No live interaction with the host filesystem** – Changes in the host’s project folder are not reflected in the container unless it is rebuilt.

**Solution:**

* Problem 1: Use **Volumes**.
* Problem 2: Use **Bind Mounts**.

## Volumes

Volumes are host-managed folders/files connected to container paths. There are two types:

### Anonymous Volumes

* Created using: `-v /some/path/in/container`
* Removed automatically when the container is removed **with** `--rm`

### Named Volumes

* Created using: `-v some-name:/some/path/in/container`
* **Not** removed automatically

### Benefits

* Host data can be passed into a container.
* Data written by the container is saved and persists.
* Named Volumes are ideal for persistent storage (e.g. logs, uploads, databases).

### Notes

* Docker manages volume locations internally.
* Use **Bind Mounts** if you want to directly view or edit stored data.

Anonymous Volumes can prevent container-internal folders from being overwritten by Bind Mounts.

Removal Behaviour:

* Anonymous Volumes are removed only if `--rm` is used.
* Named Volumes must be removed manually.

## Bind Mounts

Bind Mounts are similar to Volumes but differ in how they connect host paths:

* Created using: `-v /absolute/host/path:/path/in/container`

### Use Cases

* Share live-updating data (e.g. source code during development).
* Inspect development data.

**Avoid Bind Mounts in production** – they compromise container isolation.

## Key Docker Commands

```bash
docker run -v /path/in/container IMAGE
# Anonymous Volume

docker run -v some-name:/path/in/container IMAGE
# Named Volume

docker run -v /path/on/host:/path/in/container IMAGE
# Bind Mount

docker volume ls
# List all volumes

docker volume create VOL_NAME
# Create a named volume

docker volume rm VOL_NAME
# Remove volume by name/ID

docker volume prune
# Remove all unused volumes
```

**Topics Covered:**

* Data & Volumes
* Volumes
* Bind Mounts
* Key Docker Commands
