class fedserv::mediagoblin {

  include postgresql::server

  anchor { 'mediagoblin::start': } ->
  package { [
              'git-core',
              'nginx',
              'python',
              'python-dev',
              'python-lxml',
              'python-imaging',
              'python-virtualenv',
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
    ensure => present,
    owner  => 'mediagoblin',
    group  => 'mediagoblin',
    source => 'puppet:///modules/fedserv/mediagoblin/env_setup.sh',
    mode   => 0755,
  } ->
  exec { 'setup_mediagoblin_environment':
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
    ensure => present,
    owner  => 'mediagoblin',
    group  => 'mediagoblin',
    source => 'puppet:///modules/fedserv/mediagoblin/mediagoblin_local.ini',
    mode   => 0644,
  } ->
  file { '/srv/mediagoblin/db_update.sh':
    ensure => present,
    owner  => 'mediagoblin',
    group  => 'mediagoblin',
    source => 'puppet:///modules/fedserv/mediagoblin/db_update.sh',
    mode   => 0755,
    notify => Exec['db_update'],
  } ->
  exec { 'db_update':
    path    => '/bin:/usr/bin:/usr/local/bin',
    user    => 'mediagoblin',
    cwd     => '/srv/mediagoblin/mediagoblin',
    command => '/srv/mediagoblin/db_update.sh',
    logoutput => true,
    refreshonly => true,
  } ->
  file { '/etc/init.d/mediagoblin-paster':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/fedserv/mediagoblin/mediagoblin-paster',
    mode   => 0755,
  } ->
  service { 'mediagoblin-paster':
    ensure => running,
    enable => true,
    provider => debian,
  } ->
  file { '/etc/init.d/mediagoblin-celeryd':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/fedserv/mediagoblin/mediagoblin-celeryd',
    mode   => 0755,
  } ->
  service { 'mediagoblin-celeryd':
    ensure => running,
    enable => true,
    provider => debian,
  } ->
  file { '/etc/nginx/sites-enabled/default':
    ensure => absent,
  } ->
  file { '/etc/nginx/sites-enabled/mediagoblin.conf':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/fedserv/mediagoblin/nginx.conf',
    mode   => 0755,
  } ->
  file { '/srv/mediagoblin/mediagoblin/user_dev/':
    ensure => directory,
    owner => 'mediagoblin',
    group  => 'mediagoblin',
    mode   => 0711,
  } ->
  service { 'nginx':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  } ->
  anchor { 'mediagoblin::end': }

}
