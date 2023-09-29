require_relative "line"

module EnvFileSyrup
  module Lines
    class KeyValueLine < Line
      attr_reader :key, :value, :comment

      def initialize(key, value, comment = nil)
        @key = key.strip
        @value = clean_value(value)
        @comment = comment&.strip
      end

      def clone
        KeyValueLine.new(@key, @value, @comment)
      end

      def to_s
        return "#{@key}=#{@value} #{@comment}" if @comment

        "#{@key}=#{@value}"
      end

      private

      def clean_value(value)
        return nil if value.nil? || value.strip == ""

        remove_surrounding_quotes(value.strip)
      end

      def remove_surrounding_quotes(value)
        value.strip.sub(/\A(['"])(.*)\1\z/m, '\2')
      end
    end
  end
end
