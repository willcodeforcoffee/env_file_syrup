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

    # Merge another EnvFile into this one and generate a new EnvFile with the results
    def merge(with_env_file)
      unless with_env_file.is_a?(::EnvFileSyrup::EnvFile)
        raise ArgumentError,
              "argument must be an instance of EnvFile"
      end

      merged_file = EnvFile.new

      merged_file.send(:add_cloned_lines, @lines)
      merged_file.send(:merge_lines_with, with_env_file.lines)

      merged_file
    end

    def [](key)
      @lines.select { |line| line.respond_to?(:key) && line.respond_to?(:value) }
            .select { |line| line.key == key }[0]&.value
    end

    # Generate a hash of values based only on the key/value rows from the EnvFile
    def to_h
      @lines.select(&:key_value?)
            .to_h { |line| [line.key, line.value] }
    end

    # Export the entire EnvFile as a valid .env file formatted string
    def to_s
      "#{@lines.map(&:to_s).join("\n")}\n"
    end

    private

    def add_cloned_lines(lines)
      lines.each do |line|
        add_line(line.clone)
      end
    end

    def merge_lines_with(lines)
      add_blank_line = true
      lines.each do |line|
        if line.key_value?
          add_blank_line = merge_key_value_line(line)
        else
          # Put a newline in the first time we encounter a non-key/value line to nicely divide where files were merged
          add_line(::EnvFileSyrup::Lines::BlankLine.new) if add_blank_line
          add_blank_line = false

          add_line(line.clone)
        end
      end
    end

    def merge_key_value_line(kv_line)
      key_line = @lines.select { |l| l.key_value? && l.key == kv_line.key }[0]
      if key_line.nil?
        add_line(kv_line.clone)
        true
      else
        key_line.merge(kv_line)
        false
      end
    end
  end
end
