FROM nginx:stable-alpine

LABEL description="Docker container for building static sites with the Hugo static site generator."
LABEL maintainer="Jeff Fogarty <jeff@fogarty.org>"

COPY public/ /usr/share/nginx/html/
EXPOSE 80