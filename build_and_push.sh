#!/bin/bash

# Set Docker Hub credentials
DOCKER_USERNAME="your_dockerhub_username"
DOCKER_PASSWORD="your_dockerhub_password"
IMAGE_NAME="deployproject"

# Login to Docker Hub
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin

# Build the Docker image
docker build -t $DOCKER_USERNAME/$IMAGE_NAME .

# Push the Docker image to Docker Hub
docker push $DOCKER_USERNAME/$IMAGE_NAME
