module PuppetTwitch

  # Logger just prints to STDOUT.
  # When the server is running in the foreground (not Daemonized),
  # all output is visible in the terminal.
  # When the server is running as a Daemon,
  # STDOUT is redirected to a logfile,
  # so this simple logger works for both scenarios

  class Logger

    DEBUG = 0
    INFO  = 1
    WARN  = 2
    ERROR = 3

    attr_accessor :level

    def initialize(level = INFO)
      @level = level
    end

    def debug(message)
      log DEBUG, "Log [DEBUG]: #{message}"
    end
    def info(message)
      log INFO, "Log [INFO]: #{message}"
    end
    def warn(message)
      log WARN, "Log [WARN]: #{message}"
    end
    def error(message)
      log ERROR, "Log [ERROR]: #{message}"
    end

    private

    def log(level, message)
      puts message if level >= @level
    end

  end
end
