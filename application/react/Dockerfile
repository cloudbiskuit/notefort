# Base image
FROM node:18-alpine

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY . .

# Build the React app
RUN npm run build

# Use a lightweight Nginx web server to serve the React app
FROM nginx:1.23.3-alpine

# Copy the React Built from stage 0
COPY --from=0 /usr/src/app/dist /usr/share/nginx/html

# Copy Nginx custom configuration to the Nginx directory
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the default Nginx port
EXPOSE 3000

# Command to start Nginx
CMD ["nginx", "-g", "daemon off;"]
