# Use an official Node.js runtime as a parent image
FROM node:alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Use a lighter version of Node.js for serving the app
FROM node:alpine

# Set the working directory in the container
WORKDIR /app

# Copy the build output from the builder stage to the app directory
COPY --from=builder /app/build ./build

# Expose the port on which your React app will run
EXPOSE 3000

# Command to run the React app
CMD ["npx", "serve", "-s", "build"]
