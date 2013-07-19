class fedserv::aptitude_update {
  exec { 'aptitude_update':
    command => 'aptitude update',
    path    => '/bin:/usr/bin:/usr/local/bin',
  }
}
