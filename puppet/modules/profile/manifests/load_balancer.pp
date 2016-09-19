class profile::load_balancer {

  class { '::haproxy':
    global_options   => {
      'log'     => "${::ipaddress} local0",
      'chroot'  => '/var/lib/haproxy',
      'pidfile' => '/var/run/haproxy.pid',
      'maxconn' => '4000',
      'user'    => 'haproxy',
      'group'   => 'haproxy',
      'daemon'  => '',
      'stats'   => 'socket /var/lib/haproxy/stats',
    },
    defaults_options => {
      'mode'    => 'http',
      'log'     => 'global',
      'stats'   => 'enable',
      'option'  => [
        'httplog',
        'dontlognull',
        'http-server-close',
        'forwardfor except 127.0.0.0/8',
        'redispatch',
      ],
      'retries' => '3',
      'timeout' => [
      'http-request 10s',
        'queue 1m',
        'connect 10s',
        'client 1m',
        'server 1m',
        'http-keep-alive 10s',
        'check 10s',
      ],
      'maxconn' => '3000',
    },
  }

  haproxy::frontend { 'fe':
    ipaddress     => '*',
    ports         => '80',
    options       => {
      'default_backend' => 'be',
      'acl' => [
        'url_dug url_sub dug',
        'url_solr url_sub solr',
        ],
      'use_backend' => [
        'be_dug if url_dug',
        'be_solr if url_solr',
        ],
      'default_backend' => 'be_dug',
    },
  }

  haproxy::backend { 'be_dug':
    options => {
      'option'  => [
        'forwardfor',
      ],
    'balance' => 'leastconn',
    'server' => 'node01 node01.example.com:8080 check inter 1000',
    },
  }

  haproxy::backend { 'be_solr':
    options => {
      'option'  => [
        'forwardfor',
      ],
    'balance' => 'leastconn',
    'server' => 'node02 node02.example.com:8080 check inter 1000',
    },
  }

#  haproxy::listen { 'dug':
#    collect_exported => false,
#    ipaddress        => '0.0.0.0',
#    ports            => '80',
#  }

#  haproxy::balancermember { 'dug01':
#    listening_service => 'dug',
#    server_names      => 'node01.example.com',
#    ipaddresses       => '192.168.10.11',
#    ports             => '8080',
#    options           => 'check',
#  }

#  haproxy::balancermember { 'dug02':
#    listening_service => 'dug',
#    server_names      => 'node02.example.com',
#    ipaddresses       => '192.168.10.12',
#    ports             => '8080',
#    options           => 'check',
#  }
}
