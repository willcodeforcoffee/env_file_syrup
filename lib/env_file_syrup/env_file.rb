require_relative "lines/parser"

module EnvFileSyrup
  class EnvFile
    class << self
      def parse(env_file_content)
        env_file = EnvFile.new

        line_no = 0
        env_file_content.each_line do |line|
          line_no += 1
          parsed_line = ::EnvFileSyrup::Lines::Parser.parse(line)

          raise EnvFileSyntaxError.new(line_no, line) if parsed_line.nil?

          env_file.lines << parsed_line
        end

        env_file
      end
    end

    attr_reader :lines

    def initialize
      @lines = []
    end

    def add_line(line)
      @lines << line
    end
  end
end
