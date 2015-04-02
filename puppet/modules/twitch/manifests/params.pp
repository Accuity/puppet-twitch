class twitch::params {

  $user    = 'twitch'
  $uid     = 2023
  $home    = "/home/${user}"

  $bind    = '0.0.0.0'
  $port    = 2023
  $run_dir = '/var/run/puppet-twitch'

  $service = 'puppet-twitch'
  $puppet  = '/bin/puppet'

}
