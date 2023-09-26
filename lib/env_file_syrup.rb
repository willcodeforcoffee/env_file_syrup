require_relative "env_file_syrup/version"
require_relative "env_file_syrup/env_file"

module EnvFileSyrup
  class Error < StandardError; end

  class EnvFileSyntaxError
    attr_reader :line_no, :line

    def initialize(line_no, line)
      @line_no = line_no
      @line = line
    end

    def to_s
      "Invalid syntax on line #{line_no}: #{line}"
    end
  end
end
