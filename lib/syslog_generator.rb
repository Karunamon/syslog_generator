require "syslog_generator/version"
require 'random-word'
require 'syslog_protocol'
require 'socket'

# Initialize a new logger endpoint, setting up the appropriate socket from options.
module SyslogGenerator
  class Logger
    attr_accessor :options

    def initialize(options)
      self.options = options
      @formatter = SyslogProtocol::Logger.new(`hostname`.strip, options[:progname], options[:facility])
      @socket = case options[:protocol].downcase
                when 'udp'
                  UDPSocket.new
                when 'tcp'
                  TCPSocket.new
                else fail 'Invalid protocol specified.'
                end
    end

    def send(text)
      text.is_a?(Array) ? @payload = @formatter.info(text.join(' ')) : @payload = @formatter.info(text)
      self.options[:test] ? puts(@payload) : @socket.send(@payload, 0, self.options[:server], self.options[:port])
    end

    def start
      if self.options[:count] != -1
        self.options[:count].times { self.send RandomWord.nouns.take(self.options[:words]) }
      else
        loop { self.send RandomWord.nouns.take(self.options[:words]) }
      end
    end

  end
end

