class twitch::test::vagrant inherits twitch {

  # This is used by vagrant to install a local gem, not the one from rubygems,
  # and to add a password and shell to the twitch user for debugging

  $user = $twitch::params::user

  User[$user] {
    password => '$1$rUm9sa/i$Wl5PlNM31sQ0GtCLgKYeg1', # password = twitch
    shell    => '/bin/bash',
  }

  Package['puppet-twitch'] {
    source => '/opt/puppet-twitch/pkg/puppet-twitch-latest.gem',
  }
}
