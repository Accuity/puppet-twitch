class test {

  take_your_time(5)

  file { '/opt/foo':
    ensure => present,
  }

  exec { 'append timestamp':
    # something that changes each time
    # "tail -f /opt/foo" to see when puppet runs
    command => "echo '$::system_uptime' | tee -a /opt/foo",
    path    => [$::path]
  }

  File['/opt/foo'] -> Exec['append timestamp']
}
