# A Docker walkthrough

Using this project for my own understanding and hopefully will help a few other people out there as well.
My use case was a PHP application with MongoDB.

### My environment
- Mac OSX El Capitan 10.11.2
- Docker version 1.9.1, build a34a1d5
- docker-machine version 0.5.6, build 61388e9
- VirtualBox Version 5.0.12 r104815

Note: docker-machine is required because docker does not run natively on OSX

### The dockerfile
This is used to build your image. Typically for your project you will use a base image
and then add the tools and configuration needed for your own project. If you've ever used Vagrant and
Vagrantfile this is similar.

### Getting your web application running
Note: These commands are in init.sh, just run the script in your docker quickstart terminal

__1. Start your docker quickstart terminal__

__2. Build your image__

$ docker build -t webappimage .

__3. Run container for mongo and run mongod command__

$ docker run --name mongod -p 27017:27017 -d mongo bash -c 'mongod'

__4. Run container for mongo, link to previous container, and run mongorestore__

$ docker run -it --link mongod:mongod -v "$DIRECTORY/dump":/tmp/dump -d mongo bash -c 'mongorestore -h mongod -p 27017 /tmp/dump'

__5. Run container for webapp, linked to mongo container__

$ docker run --name webapp --link mongod:mongod -v "$DIRECTORY/webapp":/var/www/html -p 8080:80 -d webappimage

__6. Should see two containers running__

$ docker ps

__7. Open the webpage__

$ open http://192.168.99.100:8080/

If something goes wrong in the process you can stop and remove all containers by doing

$ docker stop $(docker ps -a -q)

$ docker rm $(docker ps -a -q)