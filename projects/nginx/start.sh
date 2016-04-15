# https://hub.docker.com/_/nginx/
# docker pull nginx

docker run --name my-nginx --dns 8.8.8.8 -v $PWD/nginx.conf:/etc/nginx/nginx.conf:ro -v $PWD/default.conf:/etc/nginx/conf.d/default.conf -v $PWD:/usr/share/nginx/html:ro -d -p 8888:80 nginx
