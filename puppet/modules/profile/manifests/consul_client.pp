class profile::consul_client {

  class { '::consul':
    config_hash => {
      'data_dir'   => '/opt/consul',
      'datacenter' => 'eu-west',
      'log_level'  => 'INFO',
      'node_name'  => 'agent',
      'retry_join' => ['192.168.10.30', '192.168.10.31', '192.168.10.32'],
    }
  }

}
