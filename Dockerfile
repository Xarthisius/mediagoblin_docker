# Start off at Ubuntu 14.04
FROM    ubuntu:14.04
MAINTAINER Michael Macnair

# Stop lots of debconf issues, with one of these solutions:
# ENV TERM linux
RUN     echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install needed OS packages
RUN     apt-get update
RUN     apt-get install --force-yes -y git-core python python-dev python-setuptools python-lxml python-imaging python-psycopg2 build-essential autoconf postgresql-client python-babel
# video dependencies
RUN     apt-get install --force-yes -y python-gi python3-gi gstreamer1.0-tools gir1.2-gstreamer-1.0 gir1.2-gst-plugins-base-1.0 gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad gstreamer1.0-libav python-gst-1.0
# local files dependencies
RUN     apt-get install --force-yes -y python-pyexiv2

# Make a home for mediagoblin and clone the repo
RUN	mkdir -p /opt/
RUN     git clone --no-checkout https://gitorious.org/mediagoblin/mediagoblin.git /opt/mediagoblin
WORKDIR /opt/mediagoblin
RUN     git checkout HEAD # can change HEAD to a release e.g. 0.8.0
RUN     git submodule update --init

# set up the deps and main code
RUN	autoconf
RUN     ./configure --without-virtualenv
RUN     make
RUN     python setup.py develop

# install flup for fcgi
RUN     easy_install flup

# Fix for bug #5065, and add option to never transcode
ADD     ./skip_transcode.patch /opt/mediagoblin/skip_transcode.patch
RUN     patch -p1 < skip_transcode.patch
# Fix for unpatched bug
ADD     ./file_extension.patch /opt/mediagoblin/file_extension.patch
RUN     patch -p1 < file_extension.patch
# Work around a bug in Gst
ADD     ./GstPbutils_import_workaround.patch /opt/mediagoblin/GstPbutils_import_workaround.patch
RUN     patch -p1 < GstPbutils_import_workaround.patch

# Plugins
RUN     git clone https://github.com/msm-/gmg_localfiles.git /opt/mediagoblin/mediagoblin/plugins/gmg_localfiles

# Configuration files
ADD     ./mediagoblin_local.ini /opt/mediagoblin/mediagoblin_local.ini
ADD     ./paste_local.ini /opt/mediagoblin/paste_local.ini

# Expose the port and set the command to run
EXPOSE  6543
# Prior to running the first time, you need to setup the database:
# 	docker-compose run mediagoblin gmg dbupdate
CMD     ["/opt/mediagoblin/lazyserver.sh", "--server-name=broadcast"]
