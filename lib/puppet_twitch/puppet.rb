module PuppetTwitch

  class Puppet
    class << self

      def is_running?
        lock_file_path_cmd = 'puppet config print agent_catalog_run_lockfile'
        lock_file_path = `#{sudo_if_required lock_file_path_cmd}`.strip
        if $?.to_i != 0
          raise StandardError, "Failed to find puppet lock file path: #{lock_file_path}"
        end
        File.exists?(lock_file_path)
      end

      def run_puppet(async = true)
        command = async ? 'puppet agent --onetime' : 'puppet agent --onetime --no-daemonize'
        output = `#{sudo_if_required command}`
        exit_code = $?
        unless [0, 2].include?(exit_code.to_i) # 2 indicates a puppet change, 3 is a failure
          raise StandardError, "Error running puppet: #{exit_code}: #{output}"
        end
      end

      def sudo_if_required(command)
        "sudo #{command}" unless Gem.win_platform?
      end

    end
  end
end
