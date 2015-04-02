module Puppet::Parser::Functions
  newfunction(:take_your_time, :type => :statement) do |args|

    time_to_waste = args[0].to_i

    sleep time_to_waste
  end
end
