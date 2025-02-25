# Base image
FROM nginx:1.23.3-alpine

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose ports for HTTP
EXPOSE 80

# Command to start Nginx
CMD ["nginx", "-g", "daemon off;"]
