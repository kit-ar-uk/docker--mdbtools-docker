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
        mkdir -p "/opt/mdbdata" && \
        cd /tmp && \
        git clone https://github.com/brianb/mdbtools.git && \
    cd mdbtools && \
    git fetch origin pull/137/head:fix-16k-memo-limit && \
    git checkout fix-16k-memo-limit && \
    autoreconf -i -f && \
    ./configure --with-unixodbc=/usr/local --mandir=/usr/share/man && make && make install && \
    cp README "/opt/mdbdata/" && \
    cd /tmp && rm -r mdbtools && \
    apk del autoconf automake build-base glib-dev libc-dev unixodbc-dev flex-dev git && \
    echo "In order to work interactively, mount a volume to /opt/mdbdata before starting this docker container." >> "/opt/mdbdata/README" && \
    echo "Example: docker run -it --rm -v /path/to/host/directory:/opt/mdbdata rillke/mdbtools-docker bash" >> "/opt/mdbdata/README"

COPY scripts/* /usr/bin

# set pager used by `man` to less
ENV PAGER="less"

WORKDIR "/opt/mdbdata"

