ARG BASE_IMAGE=debian:bullseye

# #########################################################################
FROM ${BASE_IMAGE} as final

LABEL maintainer="webmaster@kit-ar.com"

ENV DEBIAN_FRONTEND="noninteractive"

# Suppress an apt-key warning about standard out not being a terminal. Use in this script is safe.
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE="DontWarn"

## prob won't be needed since, on of 2020-01-09, pyhelm didn't support helm3
## uncomment if really needed
# ENV PYHELM_PIP3=pyhelm

SHELL ["/bin/bash", "-c"]

RUN \
    echo "===> Enabling Multiverse..."  && \
    sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list && \
    \
    echo "===> Speeding up apt and dpkg..."  && \
    echo "force-unsafe-io"                 > /etc/dpkg/dpkg.cfg.d/02apt-speedup         && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache               && \
    echo "APT::Install-Recommends \"0\";"  > /etc/apt/apt.conf.d/no-install-recommend   && \
    echo "APT::Install-Suggests \"0\";"    > /etc/apt/apt.conf.d/no-install-suggested   && \
    \
    echo "===> Initial packages update"  && \
    apt-get    update  && \
    apt-get -y install \
          apt-transport-https \
          lsb-release \
        #   software-properties-common \
        #   apt-utils dialog \
    && \
    \
    echo "===> Adding PPAs..."  && \
    echo OFF: ..... && \
    apt-get    update  && \
    \
    echo OFF:echo "===> Updating TLS certificates..."         && \
    echo OFF:apt-get -y install \
            ca-certificates \
            openssl \
            ssl-cert \
    && \
    \
    echo OFF:echo "===> Upgrading distribution..."  && \
    echo OFF:apt-get -y dist-upgrade && \
    \
    echo "===> Adding usefull packages ..."  && \
    apt-get -y install  \
            make \
            \
            bash \
            bash-completion \
            less \
            nano \
            jq \
            \
            curl \
            wget \
            \
            zip \
            unzip \
            xz-utils \
            p7zip-full \
            \
            git \
            \
            mc \
            dos2unix \
            \
            postgresql-client \
            default-mysql-client \
            sqlite3 \
            \
    && \
    echo "===> Adding mdbtools ..."  && \
    apt-get -y install  \
            \
            man \
            mdbtools \
    && \
    echo "===> Cleaning up ..."  && \
    # apt-get purge --autoremove -y \
    #     gcc g++ \
    # || true \
    # && \
    apt-get autoremove --purge -y && \
    apt-get clean              -y && \
    rm -rf \
        "${HOME}/.cache" \
        /var/lib/apt/lists/* \
        /tmp/*               \
        /var/tmp/*           \
    && \
    echo "..."


COPY scripts/* /usr/bin
RUN  chmod a+x /usr/bin/*.sh

# set pager used by `man` to less
# ENV PAGER="less"

WORKDIR "/opt/mdbdata"

