# Author: Tran Huu Cuong
#
# Build: docker build -t tranhuucuong91/apt-cacher-ng .
# Run: docker run -d -p 3142:3142 --name apt-cacher-run tranhuucuong91/apt-cacher-ng
#
# and then you can run containers with:
#   docker run -it --rm -e http_proxy=http://dockerhost:3142/ debian bash
#
# Ex:
#   docker run -it --rm -e http_proxy=http://172.17.42.1:3142/ ubuntu bash

FROM debian:jessie
MAINTAINER Tran Huu Cuong "tranhuucuong91@gmail.com"

# using apt-cacher-ng proxy for caching deb package
# RUN echo 'Acquire::http::Proxy "http://172.17.42.1:3142/";' > /etc/apt/apt.conf.d/01proxy

# Install apt-cacher-ng
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-cacher-ng \
    && rm -rf /var/lib/apt/lists/*

# config apt-cacher-ng to allow pass-through mode
COPY config/acng.conf /etc/apt-cacher-ng/acng.conf

# Create mount point
VOLUME ["/var/cache/apt-cacher-ng"]

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

# Expose port apt-cacher-ng
EXPOSE 3142

# Start service
CMD ["apt-cacher-ng"]

