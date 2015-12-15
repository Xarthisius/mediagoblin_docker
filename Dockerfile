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
    gstreamer1.0-libav python-gst-1.0 python-pyexiv2 \
    wget sudo unzip \
    krb5-locales libasn1-8-heimdal libcurl3-gnutls libgssapi-krb5-2 \
    libgssapi3-heimdal libhcrypto4-heimdal libheimbase1-heimdal \
    libheimntlm0-heimdal libhx509-5-heimdal libk5crypto3 libkeyutils1 \
    libkrb5-26-heimdal libkrb5-3 libkrb5support0 libldap-2.4-2 libmysqlclient18 \
    libpython-stdlib libpython2.7-minimal libpython2.7-stdlib libroken18-heimdal \
    librtmp0 libsasl2-2 libsasl2-modules libsasl2-modules-db libwind0-heimdal \
    mysql-common python python-minimal python-mysqldb python-pycurl \
    python2.7 python2.7-minimal python-werkzeug supervisor && \
  easy_install flup && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && wget --quiet https://github.com/nephics/tornado/archive/streambody.zip && \
  unzip -qq streambody.zip && cd tornado-streambody/ && \
  python setup.py install && rm -rf  /tmp/*streambody*

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

RUN cd /tmp && \
   git clone -b mediagoblin https://github.com/Xarthisius/curldrop.git && \
   cp /tmp/curldrop/*.py /opt/mediagoblin/ && \
   rm -rf /tmp/curldrop

WORKDIR /opt/mediagoblin

RUN patch -p1 < /tmp/foo.patch
# for p in /tmp/*.patch ; do patch -p1 < $p ; done && \
# Plugins
RUN git clone -b ythub https://github.com/Xarthisius/gmg_localfiles.git \
  /opt/mediagoblin/mediagoblin/plugins/gmg_localfiles

# Configuration files
ADD ./mediagoblin_local.ini /opt/mediagoblin/mediagoblin_local.ini
ADD ./paste_local.ini /opt/mediagoblin/paste_local.ini
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD tasks.conf /etc/supervisor/conf.d/tasks.conf
ADD commit.py /opt/mediagoblin/commit.py

CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
# Expose the port and set the command to run
#EXPOSE  [6543, 8888]

# Prior to running the first time, you need to setup the database:
# 	docker-compose run mediagoblin gmg dbupdate
#CMD     ["/opt/mediagoblin/lazyserver.sh", "--server-name=broadcast"]
