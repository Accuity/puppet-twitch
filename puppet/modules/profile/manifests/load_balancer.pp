class profile::load_balancer {

    class { '::haproxy': }

    haproxy::listen { 'dug':
        collect_exported => false,
        ipaddress        => '0.0.0.0',
        ports            => '80',
    }

    haproxy::balancermember { 'dug01':
        listening_service => 'dug',
        server_names      => 'node01.example.com',
        ipaddresses       => '192.168.10.11',
        ports             => '8080',
        options           => 'check',
    }

    haproxy::balancermember { 'dug02':
        listening_service => 'dug',
        server_names      => 'node02.example.com',
        ipaddresses       => '192.168.10.12',
        ports             => '8080',
        options           => 'check',
    }

}
