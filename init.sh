#!/usr/bin/env bash

# Enter the directory of this project
DIRECTORY=/path/to/docker-tutorial

if [ ! -d "$DIRECTORY" ]; then
  echo "Enter the directory of this project"
  exit 1
fi

docker-machine restart default
docker-machine env default
eval $(docker-machine env default)

# Build your image
docker build -t webappimage .

# Stop and remove all containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Run container for mongo and run mongod command
docker run --name mongod -p 27017:27017 -d mongo bash -c 'mongod'
# Run container for mongo, link to previous container, and run mongorestore
docker run -it --link mongod:mongod -v "$DIRECTORY/dump":/tmp/dump -d mongo bash -c 'mongorestore -h mongod -p 27017 /tmp/dump'
# Run container for webapp, linked to mongo container
docker run --name webapp --link mongod:mongod -v "$DIRECTORY/webapp":/var/www/html -p 8080:80 -d webappimage
# Should see two containers running
docker ps
# Open the webpage
open http://192.168.99.100:8080/