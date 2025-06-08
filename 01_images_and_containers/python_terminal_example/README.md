# Python Terminal Docker Example

This is a simple Python random number generator application containerized with Docker. The application takes minimum and maximum numbers as input and generates a random number in that range.

## Docker Instructions

### Navigating to the Project Folder

First, navigate to the project folder:

```bash
cd /images_and_containers/python_terminal_example
```

### Building the Docker Image

To build the Docker image from the Dockerfile, run the following command in this directory:

```bash
docker build -t python-rng .
```

This command builds a Docker image with the tag `python-rng` using the Dockerfile in the current directory (`.`).

### Running the Docker Container in Interactive Mode

Since this is a terminal application that requires user input, you need to run it in interactive mode:

```bash
docker run -it python-rng
```

This command:
- `-i`: Keeps STDIN open even if not attached (interactive)
- `-t`: Allocates a pseudo-TTY (terminal)
- `python-rng`: Specifies the image to run

The application will prompt you to enter minimum and maximum numbers, and then generate a random number within that range.

### Restarting a Stopped Container in Interactive Mode

If you've already run the container once and it has stopped, you can restart it in interactive mode:

```bash
docker start -a -i <container_id>
```

This command:
- `start`: Starts an existing stopped container
- `-a`: Attach to the container's output
- `-i`: Interactive mode (attach to STDIN)
- `<container_id>`: ID or name of the container to restart

This is useful when you want to run the same container again without creating a new one.

### Understanding Interactive Mode

Interactive mode is essential for applications that:
1. Require user input
2. Display real-time output
3. Need to interact with the user through a terminal

Without the `-it` flags (for `run`) or `-a -i` flags (for `start`), the container would start but you wouldn't be able to provide the required input.

### Stopping the Container

The container will automatically stop when the Python script completes. However, if you need to stop it manually:

1. In another terminal window, find the container ID:
   ```bash
   docker ps
   ```

2. Stop the container:
   ```bash
   docker stop <container_id>
   ```

### Removing the Container

To remove a stopped container:

```bash
docker rm <container_id>
```

### Removing the Image

To remove the Docker image:

```bash
docker rmi python-rng
```

or by image ID:

```bash
docker rmi <image_id>
```

## Tip: Container IDs

You don't need to type the entire container ID. You can use just the first few characters, enough to uniquely identify the container. For example:

```bash
# If the container ID is abc123def456
docker stop abc
```

This works as long as no other container ID starts with the same characters.
