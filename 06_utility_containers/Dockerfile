FROM node:14-alpine

WORKDIR /app

# ENTRYPOINT configures the container to run as an executable
# When using ENTRYPOINT, any command-line arguments passed to docker run
# will be appended to the entrypoint command, allowing us to run:
# docker run [container] [args] -> which becomes: npm [args]
# This makes the container behave like the npm command itself
# Unlike CMD, ENTRYPOINT arguments are not replaced but appended
ENTRYPOINT [ "npm" ]