#node default {
#  include twitch::test::vagrant
#  include test
#}

node 'haproxy' {
  include profile::haproxy
}

node 'node01', 'node02' {
  include profile::web
}