# suppress puppet warning
Package {
  allow_virtual => true,
}

node 'haproxy' {
  include profile::load_balancer
}

node 'node01', 'node02' {
  include profile::web
}