FROM nginx:alpine

ENV HUGO_VERSION="0.74.3"
ENV GITHUB_USERNAME="jtfogarty"
ENV REPO_NAME="007ba7"
ENV HUGO_TYPE=_extended

LABEL description="Docker container for building static sites with the Hugo static site generator."
LABEL maintainer="Jeff Fogarty <jeff@fogarty.org>"

USER root

RUN apk add --update \
    wget \
    git \
    ca-certificates

RUN wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    tar -xf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    chmod +x hugo && \
    mv hugo /usr/local/bin/ && \
    rm -rf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

RUN git clone https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git

RUN hugo -s ${REPO_NAME} -d /usr/share/nginx/html/

CMD nginx -g "daemon off;"

EXPOSE 1313