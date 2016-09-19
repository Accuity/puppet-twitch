class profile::web {

    $webroot_path = '/opt/web'

    class { 'nginx': }

    file { 'webroot':
        path   => $webroot_path,
        ensure => directory,
    }

    file { 'index':
        path    => "$webroot_path/index.html",
        content => "<html><body>Hello World from $::hostname</body></html>",
        owner   => 'nginx',
        group   => 'nginx',
    }

    nginx::resource::vhost { 'web':
        listen_port => 8080,
        www_root    => $webroot_path,
    }

    Nginx::Resource::Vhost['web'] -> File['webroot'] -> File['index']

    # Fix error in nginx module
    # nginx/templates/vhost/vhost_location_directory.erb
    # <% if !try_files.nil? && try_files != :undef then %>
}
