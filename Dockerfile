# Start off at Ubuntu 14.04
FROM    ubuntu:14.04
MAINTAINER Michael Macnair

# Stop lots of debconf issues, with one of these solutions:
# ENV TERM linux
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install needed OS packages
RUN     apt-get update
RUN     apt-get install --force-yes -y git-core python python-dev python-setuptools python-lxml python-imaging python-psycopg2 build-essential autoconf postgresql-client python-babel
# video dependencies
RUN     apt-get install --force-yes -y python-gi python3-gi gstreamer1.0-tools gir1.2-gstreamer-1.0 gir1.2-gst-plugins-base-1.0 gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad gstreamer1.0-libav python-gst-1.0
# local files dependencies
RUN     apt-get install --force-yes -y python-pyexiv2

# Make a home for mediagoblin and clone the repo
RUN	mkdir -p /opt/
RUN     git clone https://gitorious.org/mediagoblin/mediagoblin.git /opt/mediagoblin
WORKDIR /opt/mediagoblin
RUN     git submodule update --init

# set up the deps and main code
RUN	autoconf
RUN     ./configure --without-virtualenv
RUN     make
RUN     python setup.py develop

# install flup for fcgi
RUN     easy_install flup

# Patch the email code so that test emails are logged
ADD     ./email_logging.patch /opt/mediagoblin/email_logging.patch
RUN     patch -p0 < email_logging.patch

# plugins
RUN     git clone https://github.com/Velmont/gmg_localfiles.git ./mediagoblin/plugins/gmg_localfiles

# Configure the database connection and create the initial tables
ADD     ./mediagoblin_local.ini /opt/mediagoblin/mediagoblin_local.ini

# Expose the port and set the command to run
EXPOSE  6543
# Prior to running the first time, you need to setup the database:
# 	docker-compose run mediagoblin gmg dbupdate
CMD     ["/opt/mediagoblin/lazyserver.sh", "--server-name=broadcast"]
