FROM ubuntu:xenial

MAINTAINER Sebastian Gutsche <sebastian.gutsche@gmail.com>

RUN apt-get update -qq \
    && apt-get -qq install -y \
                              build-essential m4 libreadline6-dev libncurses5-dev wget unzip libgmp3-dev cmake \
                              autoconf autogen libtool libreadline6-dev libglpk-dev \
                              libmpfr-dev libcdd-dev libntl-dev git sudo

RUN adduser --quiet --shell /bin/bash --gecos "Singular user,101,," --disabled-password singular \
    && adduser singular sudo \
    && chown -R singular:singular /home/singular/ \
    && echo 'ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \

USER singular
ENV HOME /home/singular
ENV PATH ${HOME}/bin:${PATH}

RUN    cd /tmp \
    && git clone https://github.com/wbhart/flint2.git \
    && cd flint2 \
    && ./configure \
    && make -j \
    && sudo make install \
    && cd /tmp \
    && rm -rf flint2

# Singular
RUN    cd /opt \
    && sudo wget http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-0/singular-4.1.0p3.tar.gz \
    && sudo tar -xf singular-4.1.0p3.tar.gz \
    && sudo chown -hR singular singular-4.1.0 \
    && cd singular-4.1.0 \
    && ./autogen.sh \
    && ./configure --enable-gfanlib --with-flint=yes \
    && make -j \
    && sudo make install
