from    lopter/raring-base:latest
run     apt-get update
run     apt-get install --force-yes -y git-core python python-dev python-lxml python-imaging python-virtualenv python-psycopg2 build-essential postgresql postgresql-client sudo supervisor openssh-server
run     mkdir /srv/mediagoblin
add     ./env_setup.sh /srv/mediagoblin/env_setup.sh
run     bash -c "cd /srv/mediagoblin; chmod +x env_setup.sh; ./env_setup.sh"
add     ./email_logging.patch /srv/mediagoblin/email_logging.patch
run     bash -c "cd /srv/mediagoblin/mediagoblin; patch -p0 < ../email_logging.patch"
add     ./db_setup.sh /srv/mediagoblin/db_setup.sh
run     bash -c "cd /srv/mediagoblin; chmod +x db_setup.sh; ./db_setup.sh"
add     ./mediagoblin_local.ini /srv/mediagoblin/mediagoblin/mediagoblin_local.ini
add     ./db_update.sh /srv/mediagoblin/db_update.sh
run     bash -c "cd /srv/mediagoblin; chmod +x db_update.sh; cd mediagoblin; ../db_update.sh"
add     ./run_app.sh /srv/mediagoblin/run_app.sh
run     bash -c "cd /srv/mediagoblin; chmod +x run_app.sh"
run     echo "root:secret" | chpasswd
run     mkdir -p /var/run/sshd
run     mkdir -p /var/log/supervisor
run     locale-gen en_US en_US.UTF-8
add     ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
expose  22
expose  6543
cmd     ["/usr/bin/supervisord", "-n"]
