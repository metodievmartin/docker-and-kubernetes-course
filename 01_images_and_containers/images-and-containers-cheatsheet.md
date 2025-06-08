# Images & Containers Cheat Sheet

## Images

Images are one of the two core building blocks Docker is all about (the other one is **Containers**).

- Images are blueprints/templates for containers.
- They are **read-only** and contain the application and necessary application environment (OS, runtimes, tools, etc.).
- Images do **not run** themselves — they are executed as containers.
- Images can be:
    - Pre-built (e.g. official images on [DockerHub](https://hub.docker.com/))
    - Custom-built via a `Dockerfile`

### Dockerfile

- A `Dockerfile` contains instructions executed during the image build (`docker build .`)
- Each instruction creates a **layer** in the image
- Layers allow efficient rebuilds and sharing
- The `CMD` instruction is special: it runs when a **container is started**, not during the image build

## Containers

- Containers are the other key Docker building block
- A container is a **running instance** of an image
- When created (`docker run`), a **thin read-write layer** is added on top of the image
- Multiple containers can be created from the same image
- Containers run in **isolation** and do not share state or data
- You must start a container to run the application inside it

## Key Docker Commands

For full command options, use `--help`:
```bash
docker --help
docker run --help
```

Also see the full Docker CLI docs: [Docker Run Reference](https://docs.docker.com/engine/reference/run/)

**Important:** You will only use a fraction of these commands in daily use!

### Building and Running Images

```bash
docker build .                  # Build a Dockerfile into an image
docker run IMAGE_NAME          # Run a container from an image
```

- `-t NAME:TAG` — Assign name and tag to image
- `--name NAME` — Assign name to container
- `-d` — Detached mode (run in background)
- `-it` — Interactive mode (attach terminal input)
- `--rm` — Auto-remove container on stop

### Viewing Images and Containers

```bash
docker ps                      # List running containers
docker ps -a                  # List all containers
docker images                  # List local images
```

### Removing Images and Containers

```bash
docker rm CONTAINER           # Remove container by name or ID
docker rmi IMAGE              # Remove image by name or ID
docker container prune        # Remove all stopped containers
docker image prune            # Remove untagged images
docker image prune -a         # Remove all local images
```

### Pushing and Pulling Images

```bash
docker push IMAGE             # Push image to DockerHub
docker pull IMAGE             # Pull image from DockerHub
```

## Summary

- **Images** are templates
- **Containers** are running instances
- Use `docker build` to create images
- Use `docker run` to start containers
- Clean up with `docker rm`, `docker rmi`, and prune commands
