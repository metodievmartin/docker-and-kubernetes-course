# Base image - Use Node.js version 14 as our foundation
# This provides us with a pre-configured Node.js environment
FROM node:14

# Set the working directory inside the container
# All subsequent commands will run in this directory
WORKDIR /app

# Copy only the package.json file first
# This is a Docker optimization that allows us to leverage layer caching
# If package.json hasn't changed, we can use the cached node_modules
COPY package.json /app

# Install all dependencies defined in package.json
# The dependencies will be cached in a Docker layer if package.json hasn't changed
RUN npm install

# Copy the rest of the application code to the container
# This happens after npm install to leverage Docker's layer caching
COPY . /app

# Expose port 3000 to the outside world
# This is the default port that React's development server uses
EXPOSE 3000

# Command to run when the container starts
# Uses npm start script defined in package.json (starts the React development server)
CMD ["npm", "start"]