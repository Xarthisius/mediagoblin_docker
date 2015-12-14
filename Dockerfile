FROM    ubuntu:14.04
MAINTAINER Kacper Kowalik <xarthisius.kk@gmail.com>

# Stop lots of debconf issues, with one of these solutions:
# ENV TERM linux
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install needed OS packages
RUN apt-get update && \
  apt-get install --force-yes -y \
    git-core python python-dev python-setuptools python-lxml python-imaging \
    python-psycopg2 build-essential autoconf postgresql-client python-babel \
    python-gi python3-gi gstreamer1.0-tools gir1.2-gstreamer-1.0 gir1.2-gst-plugins-base-1.0 \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad \
    gstreamer1.0-libav python-gst-1.0 python-pyexiv2 && \
  easy_install flup && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

ADD patches /tmp/

# Make a home for mediagoblin and clone the repo
RUN cd /opt && \
   git clone --no-checkout git://git.savannah.gnu.org/mediagoblin.git && \
   cd mediagoblin && \
   git checkout 600a170ecf208f3ae67cc16369d50c1d6e0a7dce && \
   git submodule update --init && \
   autoconf && \
   ./configure --without-virtualenv && \
   make && \
   python setup.py develop

# for p in /tmp/*.patch ; do patch -p1 < $p ; done && \
# Plugins
RUN git clone https://github.com/msm-/gmg_localfiles.git /opt/mediagoblin/mediagoblin/plugins/gmg_localfiles

# Configuration files
ADD ./mediagoblin_local.ini /opt/mediagoblin/mediagoblin_local.ini
ADD ./paste_local.ini /opt/mediagoblin/paste_local.ini

# Expose the port and set the command to run
EXPOSE  6543

WORKDIR /opt/mediagoblin

# Prior to running the first time, you need to setup the database:
# 	docker-compose run mediagoblin gmg dbupdate
CMD     ["/opt/mediagoblin/lazyserver.sh", "--server-name=broadcast"]
