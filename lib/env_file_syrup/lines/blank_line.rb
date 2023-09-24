require_relative "line"

module EnvFileSyrup
  module Lines
    class BlankLine < Line
      def to_s
        ""
      end
    end
  end
end
