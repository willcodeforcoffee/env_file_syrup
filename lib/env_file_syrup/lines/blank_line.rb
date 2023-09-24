require_relative "./line"

module EnvFileSyrup
  module Lines
    class BlankLine < Line
      def initialize; end

      def to_s
        ""
      end
    end
  end
end
