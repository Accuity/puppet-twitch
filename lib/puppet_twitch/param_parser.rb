module PuppetTwitch

  class ParamParser

    # Takes an array of parameter strings and
    # returns a hash of the parameters and their values where
    # the keys are the parameter names as symbols.
    #
    # Parameter strings can have the following formats:
    #   'name=value'    -->    { :name => 'value' }
    #   'name'          -->    { :name => true }
    #
    def self.parse(param_strings)
      params = {}
      param_strings.each { |pair|
        key_value = pair.split('=')
        if key_value.size > 2 || pair[-1] == '='
          raise StandardError, "Invalid parameter format: #{pair}"
        else
          params[key_value[0].to_sym] = (key_value.size == 1) ? true : key_value[1]
        end
      }
      params
    end

  end
end
