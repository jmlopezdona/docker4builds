# Overview

[Docker for builds](https://www.thoughtworks.com/radar/techniques/docker-for-builds)

> One of the many innovative uses of Docker that we’ve seen on our projects is a technique to manage > build-time dependencies. In the past, it was common to run build agents on an OS, augmented with dependencies needed for the target build. But with Docker it is possible to run the compilation step in an isolated environment complete with dependencies without contaminating the build agent. This technique of using Docker for builds has proven particularly useful for compiling Golang binaries, and the golang-builder container is available for this very purpose.

Thoughts and motivations to have [A productive development environment with Docker on OS X](http://www.ybrikman.com/writing/2015/05/19/docker-osx-dev/)

Using docker-machine in Windows or Mac OS X has [performance problems with shared volumes](http://oliverguenther.de/2015/05/docker-host-volume-synchronization/) in VirtualBox (when it's using vboxsf, VirtualBox Shared Folders). Therefore, we are using a custom [vagrant boot2docker box](https://github.com/blinkreaction/boot2docker-vagrant)

Next figure show overview approach:

- Using Vagrant box to run boot2docker and mount rsync and nfs folders to share them between host machine and docker container.
- It's not necessary install any tools to build the projects in the host machine, only you need use your favorite IDE and a SCM client (for example git) to pull/push the source code.
- We are using rsync type with source folder to keep file watcher functionalities inside docker container, for example, gulp/nodejs watchers.

![Overview docker4builds](./docker4builds-overview.png?raw=true)

# Install

1. [Install Vagrant, VirtualBox (and Babun  A Linux-type shell, **Windows only**)](https://github.com/blinkreaction/boot2docker-vagrant)

2. Clone this repository and up vagrant box

```bash
https://github.com/jmlopezdona/docker4builds.git
cd docker4builds
vagrant up
```

# Configure

Edit ```vagrant.yml``` file to share files and folders between host machine and VirtualBox VM, and with docker containers using volumes.

**Typical use case**: Share source files from host machine to VM VirtualBox, and share them to container using docker volumens, to build the project in to the docker container. And share some generated files from docker container to host machine.

- Configure ```rsync``` type and specific sources folders in ```rsync_folders``` option.
- Configure ```rsync_exclude``` option with generated folders in the docker container, typical information of .gitignore file.
- Configure individual mount folders with ```individual_mounts```option. For example, generated report or logs foders in the container, and use nfs mount to have read/write mode between host machine and VM VirtualBox.

## Proxy configuration

TODO

# Sample projects

Next, we include instructions about two projects examples. For your project, you need develop a docker image to build your sources and configure folders in vagrant.yml to share source code, artefacs, reports, logs, etc., between machine host and VM VirtualBox.

## Node.js sample

```bash
cd docker4builds
git clone https://github.com/jmlopezdona/seed-app-ionic.git ./projects/node/seed-app-ionic
vagrant ssh
docker build -t "node-sample:latest" --no-cache ./projects/node
docker run -it --rm -p 8100:8100 -v $PWD/projects/node/seed-app-ionic:/opt/src/seed-app-ionic -w /opt/src/seed-app-ionic node-sample:latest
npm install
bower install
gulp build --mocks
ionic serve
```
You can check the page: http://192.168.10.10:8100/

Build a image can spend a lot of time, but you can upload your docker build image and reusing without rebuild by every team mate. For example, using my docker hub account (you must use yours):

```bash
docker login
docker build -t "jmlopezdona/seed-app-ionic-build:latest" --no-cache ./projects/node
docker push jmlopezdona/seed-app-ionic-build:latest
```

```bash
docker run -it --rm -p 8100:8100 -v $PWD/projects/node/seed-app-ionic:/opt/src/seed-app-ionic -w /opt/src/seed-app-ionic jmlopezdona/seed-app-ionic-build:latest
```

## Java sample

```bash
cd docker4builds
git clone https://github.com/spring-projects/spring-boot.git ./projects/java/spring-boot
vagrant ssh
docker build -t "java-sample:latest" --no-cache ./projects/java
docker run -it --rm -p 8080:8080 -v /root/.m2:/root/.m2 -v $PWD/projects/node/spring-boot:/opt/src/spring-boot -w /opt/src/spring-boot/spring-boot-samples/spring-boot-sample-web-static java-sample:latest
mvn clean package
java -jar ./target/*.jar
```
You can check the page: http://192.168.10.10:8080/

Because we are sharing with nfs the .m2 folder inside VM VirtualBox, Maven artefacts repository is the same in the host machine, therefore you can reusing them to compile in your IDE, for example STS, Eclipse, etc.

NOTE: we have included the parameter ```--rm``` when run the docker container to remove it when exit. But we don't lost the build files because we are using a volumen with the VM VirtualBox in the proyect (```-v $PWD/spring-boot:/opt/src/spring-boot```)

# References

- [Docker Cheat Sheet](https://github.com/wsargent/docker-cheat-sheet)
- [What IP do I access when using docker and boot2docker?](http://webiphany.com/technology/2014/06/12/what-ip-do-i-access-when-using-docker-and-boot2docker.html)
- [A productive development environment with Docker on OS X](http://www.ybrikman.com/writing/2015/05/19/docker-osx-dev/)
- [Rsync exclude according to .gitignore](http://stackoverflow.com/questions/13713101/rsync-exclude-according-to-gitignore-hgignore-svnignore-like-filter-c)
- [Sharing files with host machine](https://github.com/rocker-org/rocker/wiki/Sharing-files-with-host-machine)
- [Understanding Volumes in Docker](http://container-solutions.com/understanding-volumes-docker/)
- [Docker NFS, AWS EFS & Samba/CIFS Volume Plugin](https://github.com/gondor/docker-volume-netshare)
- [Exposing mounts within Containers](https://forums.docker.com/t/exposing-mounts-within-containers/2479/3)
- [Sharing Host Volumes with Docker Containers](http://oliverguenther.de/2015/05/docker-host-volume-synchronization/)
- [Docker Machine NFS](https://github.com/adlogix/docker-machine-nfs)
- [What's the right way to setup a development environment on OS X with Docker?](http://stackoverflow.com/questions/30090007/whats-the-right-way-to-setup-a-development-environment-on-os-x-with-docker)

# TODO

- Develop base images to mobile/web projects, and later do specific project images
- Proxy configuration
- Test Windows configuration
- Using new docker native (beta)

# Appendix: Common commands

## Docker

```bash
# List containers
docker ps
# Delete all containers
docker rm $(docker ps -a -q)
# List all images
docker images
# Delete all images
docker rmi $(docker images -q)
# Enter a running docker
docker exec -it [container-id] bash
# Find out the ip container
docker inspect $(docker ps -q) | grep IPA
# Restart container that is stopped
docker start -ai 3aac3a0d824e
```

# Docker-machine

```bash
# List commands
docker-machine -h
# Update docker-machine
docker-machine upgrade default
# SSH access to docker-machine
docker-machine ssh default
# Create virtualbox docker-machine
docker-machine create -d virtualbox default
# Configure to use run commands with a docker-machine
eval "$(docker-machine env <machine-name>)"
# Get default ip
docker-machine ip default
```
