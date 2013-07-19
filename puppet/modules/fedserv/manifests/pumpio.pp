class fedserv::pumpio {

  # sudo add-apt-repository ppa:chris-lea/node.js -y
  
  anchor { 'pumpio::start': } ->
  exec { 'configure_node_repo':
    command => 'add-apt-repository ppa:chris-lea/node.js -y',
    path    => '/bin:/usr/bin:/usr/local/bin',
    creates => '/etc/apt/sources.list.d/chris-lea-node_js-raring.list',
    notify  => Exec['aptitude_update'],
  } ->
  exec { 'aptitude_update':
    command     => 'aptitude update',
    path        => '/bin:/usr/bin:/usr/local/bin',
    refreshonly => true,
  } ->
  package { [
              'nodejs',
            ]:
    ensure => installed,
  } ->
  user { 'pumpio':
    ensure     => present,
    managehome => true,
    shell      => '/bin/bash',
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
