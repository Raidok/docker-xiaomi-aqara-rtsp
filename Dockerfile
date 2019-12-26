FROM python:3-alpine

# set workdir
WORKDIR /usr/src/app

COPY live555.pc /usr/lib/pkgconfig/

# install dependencies
RUN apk add --no-cache live-media live-media-utils live-media-dev
RUN apk add --no-cache --virtual build-deps git json-c-dev libffi-dev build-base openssl-dev autoconf automake libc6-compat

# install python dependencies
RUN pip3 install --no-cache-dir python-miio

# clone code
RUN git clone https://github.com/miguelangel-nubla/videoP2Proxy.git .

# build code
RUN ./autogen.sh
RUN make
RUN make install

RUN apk del build-deps

# run code
CMD videop2proxy --ip $IP --token $TOKEN --rtsp 8554

# expose port
EXPOSE 8554
