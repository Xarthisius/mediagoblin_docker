class fedserv::pumpio::repos {
  exec { 'configure_node_repo':
    command => 'add-apt-repository ppa:chris-lea/node.js -y',
    path    => '/bin:/usr/bin:/usr/local/bin',
    creates => '/etc/apt/sources.list.d/chris-lea-node_js-raring.list',
  }

  exec { 'configure_redis_repo':
    command => 'add-apt-repository ppa:chris-lea/redis-server -y',
    path    => '/bin:/usr/bin:/usr/local/bin',
    creates => '/etc/apt/sources.list.d/chris-lea-redis-server-raring.list',
  }
}
