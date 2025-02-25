# Base image
FROM rabbitmq:3-management

# Copy RabbitMQ configuration
COPY rabbitmq.conf /etc/rabbitmq/rabbitmq.conf

# Expose the necessary ports
EXPOSE 5672 15672

# Command to start RabbitMQ
CMD ["rabbitmq-server"]