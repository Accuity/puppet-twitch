# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = (JSON.parse(File.read('nodes.json')))['nodes']

Vagrant.configure(2) do |config|

  config.vm.box = 'puppetlabs/centos-7.0-64-puppet'
  config.vm.box_version = '1.0.1'

  nodes.each do |fqdn, node_config|

    # Use hostname instead of fqdn so vagrant commands are easier to type
    hostname = fqdn.split('.')[0]
    config.ssh.insert_key = false
    config.vm.define hostname do |node|

      node.vm.hostname = fqdn
      node.vm.network :private_network, ip: node_config['ip']

      node.vm.provider :virtualbox do |vb|
        vb.customize ['modifyvm', :id, '--name', fqdn]
      end

      add_host_entries(nodes, fqdn, node)
      open_ports(node_config['ports'], node)

      if node_config['role'] == 'master'
        node.vm.synced_folder './puppet', '/etc/puppet'
        node.vm.provision :shell, inline: 'puppet master'
      end

    end
  end
end

def add_host_entries(nodes, node_fqdn, config)
  commands = nodes.collect do |host_fqdn, host_config|
    unless host_fqdn == node_fqdn
      host_command = "sudo puppet resource host #{host_fqdn} ip='#{host_config['ip']}'"
      (host_config['role'] == 'master') ? host_command << " host_aliases='puppet'" : host_command
    end
  end
  add_provision_commands(commands, config)
end

def open_ports(ports, config)
  commands = ports.collect { |port|
    "sudo firewall-cmd --zone=public --add-port=#{port}/tcp --permanent"
  }
  commands << 'sudo firewall-cmd --reload' unless ports.empty?
  add_provision_commands(commands, config)
end

def add_provision_commands(commands, config)
  config.vm.provision :shell, inline: commands.join("\n")
end
