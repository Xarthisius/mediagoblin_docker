class fedserv::pumpio {

  # sudo add-apt-repository ppa:chris-lea/node.js -y
  class { 'fedserv::pumpio::repos':
    stage   => reposetup,
  }

  anchor { 'pumpio::start': } ->
  package { [
              'nodejs',
              'redis-server',
            ]:
    ensure => installed,
  } ->
  user { 'pumpio':
    ensure     => present,
    managehome => true,
    shell      => '/bin/bash',
  } ->
  file { '/home/pumpio/.pump.io.json':
    ensure => present,
    owner  => 'pumpio',
    group  => 'pumpio',
    source => 'puppet:///modules/fedserv/pumpio/pump.io.json',
    mode   => 0644,
  } ->
  file { '/srv/pumpio':
    ensure => directory,
    owner => 'pumpio',
    group  => 'pumpio',
  } ->
  file { '/srv/pumpio/env_setup.sh':
    ensure => directory,
    owner  => 'pumpio',
    group  => 'pumpio',
    source => 'puppet:///modules/fedserv/pumpio/env_setup.sh',
    mode   => 0755,
  } ->
  exec { 'setup_pumpio_environment':
    path    => '/bin:/usr/bin:/usr/local/bin',
    user    => 'pumpio',
    cwd     => '/srv/pumpio',
    command => '/srv/pumpio/env_setup.sh',
    creates => '/srv/pumpio/pumpio/node_modules',
    environment => [
      'HOME=/home/pumpio',  # for some reason, running as a user doesn't set their $HOME
    ],
  } ->
  anchor { 'pumpio::end': }

}
