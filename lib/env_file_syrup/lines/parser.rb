require_relative "blank_line"
require_relative "comment_line"
require_relative "key_value_line"
require_relative "line"

module EnvFileSyrup
  module Lines
    class Parser
      # From https://github.com/bkeepers/dotenv/blob/master/lib/dotenv/parser.rb#L14
      LINE = /
      (?:^|\A)              # beginning of line
      \s*                   # leading whitespace
      (?:export\s+)?        # optional export
      ([\w.]+)              # key
      (?:\s*=\s*?|:\s+?)    # separator
      (                     # optional value begin
        \s*'(?:\\'|[^'])*'  #   single quoted value
        |                   #   or
        \s*"(?:\\"|[^"])*"  #   double quoted value
        |                   #   or
        [^\#\r\n]+          #   unquoted value
      )?                    # value end
      \s*                   # trailing whitespace
      (\#.*)?               # optional comment
      (?:$|\z)              # end of line
    /x.freeze

      class << self
        def parse(line)
          return BlankLine.new if line.nil? || line.strip.empty?

          return CommentLine.new(line) if line.strip.start_with?("#")

          line_match = line.scan(LINE)[0]
          return KeyValueLine.new(line_match[0], line_match[1], line_match[2]) if line_match && line_match.count >= 2

          nil
        end
      end
    end
  end
end
