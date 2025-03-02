# Base image
FROM mysql:8.0

# Copy the initialization SQL script into the container
COPY init.sql /docker-entrypoint-initdb.d/

# Expose the necessary port
EXPOSE 3307