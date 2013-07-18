class fedserv::tentio {

  include postgresql::server
  
  anchor { 'tentio::start': } ->
  package { [
              'git',
              'ruby1.9.1-full',
              'libxml2',
              'libxml2-dev',
              'libxslt1-dev',
              'build-essential',
              #'nodejs',
            ]:
    ensure => installed,
  } ->
  user { 'tentio':
    ensure     => present,
    managehome => true,
    shell      => '/bin/bash',
  } ->
  postgresql::db { 'tentio': user => 'tentio', password => postgresql_password('tentio', 'tentio_password') } ->
  file { '/srv/tentio':
    ensure => directory,
    owner => 'tentio',
    group  => 'tentio',
  } ->
  file { '/srv/tentio/env_setup.sh':
    ensure => directory,
    owner  => 'tentio',
    group  => 'tentio',
    source => 'puppet:///modules/fedserv/tentio/env_setup.sh',
    mode   => 0755,
  } ->
  exec { 'setup_tentio_environment':
    path    => '/bin:/usr/bin:/usr/local/bin',
    user    => 'tentio',
    cwd     => '/srv/tentio',
    command => '/srv/tentio/env_setup.sh',
    creates => '/srv/tentio/tentd-admin',
    logoutput => true,
    environment => [
      'HOME=/home/tentio',  # for some reason, running as a user doesn't set their $HOME
    ],
  } ->
  anchor { 'tentio::end': }
}
