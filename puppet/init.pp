stage { 'reporefresh': }
stage { 'reposetup': }
Stage['reposetup'] -> Stage['reporefresh'] -> Stage['main']

class { 'fedserv::aptitude_update':
  stage   => reporefresh,
}
class { 'fedserv':
  stage => main,
}
