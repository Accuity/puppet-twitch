class twitch (
  $user       = $twitch::params::user,
  $group      = $twitch::params::user,
  $home       = $twitch::params::home,
  $managehome = true,
  $uid        = $twitch::params::uid,
  $gid        = $twitch::params::uid,
  $bind       = $twitch::params::bind,
  $port       = $twitch::params::port,
  $run_dir    = $twitch::params::run_dir,
  $source     = undef,
  $service    = $twitch::params::service,
  $puppet     = $twitch::params::puppet,
) inherits twitch::params {

  group { $group:
    gid => $gid,
  }

  user { $user:
    uid        => $uid,
    gid        => $gid,
    home       => $home,
    managehome => $managehome,
    ensure     => present,
  }

  file { "${user} user sudo commands":
    path    => "/etc/sudoers.d/${user}",
    content => "%twitch ALL= NOPASSWD: ${puppet} config print agent_catalog_run_lockfile, ${puppet} agent --onetime, ${puppet} agent --onetime --no-daemonize\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { 'puppet-twitch run dir':
    path   => $run_dir,
    owner  => $user,
    group  => $group,
    mode   => '0644',
    ensure => directory,
  }

  package { 'puppet-twitch':
    source          => $source,
    install_options => '-N',
    provider        => gem,
  }

  service { $service:
    start   => "runuser -l ${user} -c 'puppet-twitch start dir=${run_dir} -- bind=${bind} port=${port}'",
    stop    => "runuser -l ${user} -c 'puppet-twitch stop dir=${run_dir}'",
    restart => "runuser -l ${user} -c 'puppet-twitch restart dir=${run_dir}'",
    status  => "runuser -l ${user} -c 'puppet-twitch status dir=${run_dir}'",
    ensure  => running,
  }

  User[$user] -> File['puppet-twitch run dir'] -> Service[$service] <- Package['puppet-twitch']

  File["${user} user sudo commands"] -> Service[$service]
}
