# Entorno de desarrollo

## Version A:

Instalar Docker segun Sistema Operativo:
- [Get Started with Docker for Windows](https://docs.docker.com/windows/)
- [Get Started with Docker for Mac OS X](https://docs.docker.com/mac/)
- [Get Started with Docker Engine for Linux](https://docs.docker.com/linux/)

## Version B (**version recomendada**):

Tras ver los [problemas de rendimiento con directorios compartidos](http://oliverguenther.de/2015/05/docker-host-volume-synchronization/)) de la VM boot2docker en VirtualBox (usando vboxsf, VirtualBox Shared Folders) para poder ejecutar contenedores de Docker en Mac OS X y Windows, se opta por la solución de usar una [custom boot2docker box con Vagrant](https://github.com/blinkreaction/boot2docker-vagrant).

Para la instalación de la imagen boot2docker de Vangrant seguir los pasos del enlace anterior.

## Contrucción de una imagen/contenedor para un proyecto

Para la construcción de la imagen de docker de un proyecto (en la ruta HOME_PROJECT) que venga con una imagen (p.e. josemanlopez/app-ionic):

```bash
vagrant ssh
cd <HOME_PROJECT>
docker build -t "ionic:latest" ./docker
```

Construcción del contenedor de la imagen previamente construida:

```bash
# Create and run the container con pseudo-tty
docker run -it --rm -p 8100:8100 ionic:latest

# Or with nfs volumen
./docker-machine-use-nfs.sh
docker run -v $PWD:/opt/src -it --rm -p 8100:8100 ionic:latest

# Or with rsync
docker run -v $(pwd):/opt/src -it --rm -p 8100:8100 ionic:latest
```

NOTA: se incluye el parámetro ```--rm``` de forma que al salir del contenedor se borra. Como se está usando una image con el host (boot2docker) no se pierden los ficheros que se hayan construido (p.e. node_modules, lib, etc.)

Por ejemplo, para probar el contenedor de josemanlopez/app-ionic, si se ha creado con el ejemplo anterior de rsync:

```bash
cd /opt/src
npm install
bower install
gulp build --mocks
ionic serve
```

En un navegador en el host ir a la página http://192.168.10.10:8100

# Comandos habituales docker

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

# Comandos habituales docker-machine

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

# Referencias

- https://github.com/wsargent/docker-cheat-sheet#exposing-ports
- http://webiphany.com/technology/2014/06/12/what-ip-do-i-access-when-using-docker-and-boot2docker.html
- http://www.ybrikman.com/writing/2015/05/19/docker-osx-dev/
- http://stackoverflow.com/questions/13713101/rsync-exclude-according-to-gitignore-hgignore-svnignore-like-filter-c


# TODO

- Realizar aprovisionamiento en el Dockerfile con una herramienta como Ansible
- Crear una imagen base para desarrollo web/mobile y luego imagenes específicas por proyectos a partir de estas
- Ajustar la configuración de bower para poder ejecutar como root o ver no ser root en el contenedor (http://stackoverflow.com/questions/25672924/run-bower-from-root-user-its-possible-how)
- Exponer con NFS el directorio del proyecto para poder usar un IDE en el host
  - https://github.com/rocker-org/rocker/wiki/Sharing-files-with-host-machine
  - http://container-solutions.com/understanding-volumes-docker/
  - https://github.com/gondor/docker-volume-netshare
  - https://forums.docker.com/t/exposing-mounts-within-containers/2479/3
  - http://oliverguenther.de/2015/05/docker-host-volume-synchronization/
  - https://github.com/adlogix/docker-machine-nfs
  - https://github.com/brikis98/docker-osx-dev

Lo que habia en /etc/exports
/Users -mapall=jomalopez:staff 192.168.1.138

- Ver la configuración detras de un proxy
