class fedserv::mediagoblin {

  include postgresql::server

  anchor { 'mediagoblin::start': } ->
  package { [
              'git-core',
              'python',
              'python-dev',
              'python-lxml',
              'python-imaging',
              'python-virtualenv',
              'postgresql',
              'postgresql-client',
              'python-psycopg2',
            ]:
    ensure => installed,
  } ->
  user { 'mediagoblin':
    ensure     => present,
    managehome => true,
    shell      => '/bin/bash',
  } ->
  postgresql::role { 'mediagoblin': login => true } ->
  postgresql::database { 'mediagoblin': owner => 'mediagoblin' } ->
  file { '/srv/mediagoblin':
    ensure => directory,
    owner => 'mediagoblin',
    group  => 'mediagoblin',
  } ->
  file { '/srv/mediagoblin/env_setup.sh':
    ensure => directory,
    owner  => 'mediagoblin',
    group  => 'mediagoblin',
    source => 'puppet:///modules/fedserv/mediagoblin/env_setup.sh',
    mode   => 0755,
  } ->
  exec { 'setup_environment':
    path    => '/bin:/usr/bin:/usr/local/bin',
    user    => 'mediagoblin',
    cwd     => '/srv/mediagoblin',
    command => '/srv/mediagoblin/env_setup.sh',
    creates => '/srv/mediagoblin/mediagoblin/bin',
    environment => [
      'HOME=/home/mediagoblin',  # for some reason, running as a user doesn't set their $HOME
    ],
  } ->
  file { '/srv/mediagoblin/mediagoblin/mediagoblin_local.ini':
    ensure => directory,
    owner  => 'mediagoblin',
    group  => 'mediagoblin',
    source => 'puppet:///modules/fedserv/mediagoblin/mediagoblin_local.ini',
    mode   => 0644,
  } ->
  file { '/srv/mediagoblin/db_update.sh':
    ensure => directory,
    owner  => 'mediagoblin',
    group  => 'mediagoblin',
    source => 'puppet:///modules/fedserv/mediagoblin/db_update.sh',
    mode   => 0755,
  } ->
  exec { 'db_update':
    path    => '/bin:/usr/bin:/usr/local/bin',
    user    => 'mediagoblin',
    cwd     => '/srv/mediagoblin/mediagoblin',
    command => '/srv/mediagoblin/db_update.sh',
    logoutput => true,
  } ->
  anchor { 'mediagoblin::end': }

}
