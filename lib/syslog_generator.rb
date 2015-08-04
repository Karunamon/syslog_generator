require 'syslog_generator/version'
require 'random-word'
require 'syslog_protocol'
require 'socket'
# Initialize a new logger endpoint, setting up the appropriate socket from
# the provided options.
module SyslogGenerator
  # Implementation of a log formatter/sender
  class Logger
    attr_accessor :options

    private

    def initialize_socket(options)
      case options[:protocol].downcase
      when 'udp'
        UDPSocket.new
      when 'tcp'
        TCPSocket.new
      else fail 'Invalid protocol specified.'
      end
    end

    def gen_payload(text)
      # Syslog_protocol uses different methods for each priority
      # (@formatter.debug, @formatter.emerg, etc) so we use .method to save the
      # call with the appropriate name, and .call to invoke it with the right
      # string. This won't be likely to break since we check for valid names
      # back at options parsing.
      meta_formatter = @formatter.method(options[:priority])
      if text.is_a?(Array)
        @payload = meta_formatter.call(text.join(' '))
      else
        @payload = meta_formatter.call(info(text))
      end
    end

    def gen_words
      RandomWord.nouns.take(options[:words])
    end

    public

    def initialize(options)
      self.options = options
      # TODO: Won't work on systems that don't have `hostname`?
      @formatter = SyslogProtocol::Logger.new(
        `hostname`.strip,
        options[:name],
        options[:facility]
      )
      @socket = initialize_socket(options)
    end

    def send(text)
      if options[:test]
        puts(gen_payload(text))
      else
        @socket.send(gen_payload(text), 0, options[:server], options[:port])
      end
    end

    def start
      if options[:count] != -1
        options[:count].times { send(gen_words) }
      else
        loop { send(gen_words) }
      end
    end
  end
end
