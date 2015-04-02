module PuppetTwitch

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
