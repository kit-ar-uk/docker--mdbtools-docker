FROM alpine:latest

RUN apk --no-cache add ca-certificates \
    autoconf \
    automake \
    build-base \
    glib \
    glib-dev \
    libc-dev \
    libtool \
    linux-headers \
    bison flex-dev unixodbc unixodbc-dev txt2man man \
    unrar p7zip \
    git && \
        cd /tmp && \
        git clone https://github.com/brianb/mdbtools.git && \
    cd mdbtools && \
    autoreconf -i -f && \
    ./configure --with-unixodbc=/usr/local && make && make install && \
    cd /tmp && \
    rm -r mdbtools && \
    apk del autoconf automake build-base glib-dev libc-dev unixodbc-dev flex-dev git && \
    mkdir -p "/opt/mdbdata" && \
    echo "In order to work interactively, mount a volume to /opt/mdbdata before starting this docker container." > "/opt/mdbdata/README" && \
    echo "Example: docker run -it --rm -v /path/to/host/directory:/opt/mdbdata rillke/mdbtools-docker bash"

COPY scripts/* /usr/bin

WORKDIR "/opt/mdbdata"

