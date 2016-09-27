class profile::consul_server {

  class { '::consul': 
    config_hash => {
      'bootstrap_expect' => 3,
      'client_addr'      => '0.0.0.0',
      'data_dir'         => '/opt/consul',
      'datacenter'       => 'eu-west',
      'log_level'        => 'INFO',
      'node_name'        => 'server',
      'server'           => true,
      'ui_dir'           => '/opt/consul/ui',
      'retry_join' => ['192.168.10.30', '192.168.10.31', '192.168.10.32']
    }
  }
}
