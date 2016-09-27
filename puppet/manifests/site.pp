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

node 'consul1', 'consul2', 'consul3' {
	include profile::consul_server
}

node 'consulclient1' {
  include profile::web
	include profile::consul_client
}
