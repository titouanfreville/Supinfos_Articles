FROM nginx:1.11

COPY helloworld.html /home/nginx_demo/default
COPY helloworld.config /etc/nginx/conf.d/default.conf
RUN chmod -R 777 /home/nginx_demo
