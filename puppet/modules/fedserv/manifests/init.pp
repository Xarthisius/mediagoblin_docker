class fedserv {

  /*notify { "Setting up federated services": }*/
    
  include fedserv::mediagoblin
  # include fedserv::tentio
  # include fedserv::pumpio
}
