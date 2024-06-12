#!/bin/bash

# Set Docker Hub credentials
DOCKER_USERNAME="your_dockerhub_username"
IMAGE_NAME="deployproject"

# Pull the latest Docker image
docker pull $DOCKER_USERNAME/$IMAGE_NAME

# Stop and remove any existing container
docker stop deployproject || true
docker rm deployproject || true

# Run the Docker container
docker run -d -p 9000:80 --name deployproject $DOCKER_USERNAME/$IMAGE_NAME

# Set permissions
docker exec deployproject chmod 777 /sessions
docker exec deployproject chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache /var/www/bootstrap/
docker exec deployproject chmod -R 777 /var/www/storage /var/www/bootstrap/cache /var/www/bootstrap/

# Check logs for any issues
docker logs deployproject
