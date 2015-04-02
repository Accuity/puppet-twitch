require 'daemons'
require_relative 'param_parser'

args = PuppetTwitch::ParamParser.parse(ARGV.reject {|arg| arg == '--'})
run_dir = args[:dir]
abort 'Please provide a run directory' unless run_dir

# Pids and log files will be written to run_dir directory
options = {
  :dir_mode   => :normal,
  :dir        => run_dir,
  :log_output => true,
  :monitor    => true,
}

Daemons.run(File.expand_path('../controller.rb', __FILE__), options)
