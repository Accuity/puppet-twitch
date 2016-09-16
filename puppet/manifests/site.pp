node 'haproxy' {
  include profile::haproxy
}

node 'node01', 'node02' {
  include profile::web
}