# Puppet Twitch

Puppet Twitch provides a lightweight http interface for remotely triggering puppet runs. That's it! The plan was to not use more resources than it had to, and also not open up any security holes.

Currently this project is definitely in the beta phase, there are probably a few kinks to work out, and it's worth highlighting that at the moment **puppet twitch doesn't use a "proper" http server**, it's just a TCP socket with an http shaped regex. This makes it lightweight, but there might be a whole bunch of compatibility/security issues with it, so I'm looking to swap that out (see ToDo section)

### Triggering puppet

To trigger a puppet run on a node running puppet-twitch, simply hit the `/puppet/twitch` endpoint over http. For example, to trigger puppet on `node01.example.com` running puppet-twitch on the default port:

`$ curl http://node01.example.com:2023/puppet/twitch`

Puppet-twitch will respond with one of the following (`<status code>, <body>`):
 - `202, Triggered puppet run` - The puppet run has been triggered asynchronously
 - `409, Puppet already running` - Either the server is already processing a request, or puppet's lock file exists indicating the agent is already running
 - `500, <error message>` - Something went wrong!

##### Async

You can use the `async` parameter (default `true`) to make the request wait for the puppet run to finish before returning. Note that this can be a few minutes, so timeouts etc will need to be taken into account:

`$ curl http://node01.example.com:2023/puppet/twitch?async=false`

In this case puppet-twitch will respond with `200, Puppet run complete`

### Puppet Install

There is a puppet module called `twitch` in the source that can be used to setup and install puppet-twitch. The module isn't in the forge yet so copy and paste for now.

To use the defaults on Linux, simply `include twitch`. This will:
 - Create a user and group called `twitch`
 - Add specific puppet commands to `/etc/sudoers.d/twitch` (see `init.pp` in the `twitch` module for the list of commands)
 - Create the `/var/run/puppet-twitch` directory that is writable by the `twitch` user
 - Install the gem
 - Start the server as the `twitch` user on the default port (2023)

The `twitch` class is parameterized, so user, port, run directory, etc can be configured if necessary

##### Prerequisites
 - **ruby 1.9.3** or above as `require_relative` isn't supported by lower versions
 - Open the port to incoming connections, the `twitch` module will not change any network configuration.
 - Add `/etc/sudoers.d` to the `sudoers` file. This is a common configuration and is done by default on some VMs (e.g.Vagrant boxes, EC2 instances) but the `twitch` module assumes this is already setup.

### Manual Install:

`$ gem install puppet-twitch` (run as root so that it's available to all users)

Use the `puppet-twitch` command to start/stop the server

`$ puppet-twitch {start|stop|restart|status} dir=</path/to/run/dir> [-- [bind=<binding>] [port=<port>]]`

For example to start the server on a custom port

`$ puppet-twitch start dir=/var/run/puppet-twitch -- port=8090`

And then stop it

`$ puppet-twitch stop dir=/var/run/puppet-twitch`

##### Prerequisites
 - All prerequisites from the puppet install apply
 - Create a user to run the server (one that doesn't have root permissions)
 - Allow user to run the necessary puppet commands with `sudo` and without password (see `init.pp` for commands)
 - Create a run directory for pids and logs (writable by the user)

##### Args:
 - `dir`: Absolute path for directory that will store the pids and logs. **The directory must be manually created and must be writable by the user that is running the server**. It must be provided for every action (`start`/`stop`/`status` etc), there is a ToDo to fix this
 - `bind`: The IP address to bind to, defaults to `0.0.0.0`
 - `port`: The port to listen on, defaults to `2023`

### Running from source (for development/testing)

You can use `rake install` to build and install the gem locally (I recommend using `rvm` gemsets to isolate gem installs), but you can also run the code direct from source in two ways:
 - `ruby lib/puppet-twitch/controller.rb [bind=<binding>] [port=<port>]`
 - `ruby lib/puppet-twitch/server.rb dir=</path/to/run/dir> [-- [bind=<binding>] [port=<port>]]`

The difference is that running `controller.rb` will run the server in the foreground and output will be logged to `STDOUT`. Running `server.rb` will start the server as a daemon and output will be logged to a logfile in the run directory

If you want to run the server in single threaded mode (i.e. the server doesn't fork threads for incoming connections) then set `async = false` in `controller.rb`, this is useful for debugging issues that aren't related to threading.

##### Vagrant

To test in a more isolated environment you can use vagrant, just spin up the boxes (see `nodes.json`), ssh into a node, then run puppet. After that, puppet-twitch should be running on the node and you can test by hitting the endpoint:

```
[user@localhost] $ vagrant up
[user@localhost] $ vagrant ssh node01
[vagrant@node01] $ sudo puppet agent -t
[vagrant@node01] $ curl http://localhost:2023/puppet/twitch
```

The puppet class that's applied to the nodes (`twitch::test::vagrant`) inherits from the normal `twitch` class but also:
 - Gives the `twitch` user a password (set to `twitch`) and a shell (`/bin/bash`) so you can switch to the `twitch` user for debugging
 - Installs the gem from the project's `pkg` directory that is mounted by vagrant, rather than downloading the gem from rubygems

In order to get local changes running on the vagrant machines, use the `rake latest` command which builds the gem as normal, but then also creates a symlink called `puppet-twitch-latest.gem` to the built gem. This is the file that the `twitch::test::vagrant` class looks for so that you don't have to specify a version

### ToDo:
 - Proper http server - I tried using Sinatra but it wasn't playing nice with Daemons and logging
 - Auth key/password - At the moment anyone with network access to the port can trigger a run, not a massive deal as all they can do is trigger a puppet run, but it might be nice to add a configurable key/phrase/password
 - Add support for Windows - It should be easy(-ish) to configure, I tried to write everything in an agnostic manner, but need to test and fix
 - Cache run directory - It's annoying having to provide the run directory for each action
