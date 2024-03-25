# Stage 1: Install Dependencies
FROM node:14.17.5 as installer
WORKDIR /usr/src/app

# Copy only package files first to leverage Docker caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Stage 2: Build Angular App
FROM installer as builder

# Copy only necessary configuration files
COPY angular.json tsconfig.json ./

# Copy the entire project source
COPY . .

# Build the Angular app
RUN npx ng build --configuration=production

# Stage 3: Serve Angular App using Nginx
FROM nginx:alpine

# Remove the default configuration
RUN rm /etc/nginx/conf.d/default.conf

# Add the custom Nginx configuration directly within Dockerfile
RUN echo ' \
    server { \
        listen 80; \
        server_name localhost; \
        \
        access_log  /var/log/nginx/host.access.log  main; \
        \
        location / { \
            root   /usr/share/nginx/html; \
            index  index.html index.htm; \
            try_files $uri $uri/ /index.html; \
        } \
        \
        error_page  404              /index.html; \
        \
        # redirect server error pages to the static page /50x.html \
        error_page   500 502 503 504  /50x.html; \
        location = /50x.html { \
            root   /usr/share/nginx/html; \
        } \
    } \
' > /etc/nginx/conf.d/default.conf

# Copy the built Angular app to the Nginx HTML directory
COPY --from=builder /usr/src/app/dist/the-tym /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
