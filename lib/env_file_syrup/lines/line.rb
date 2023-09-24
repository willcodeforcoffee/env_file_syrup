module EnvFileSyrup
  module Lines
    class Line
      def initialize
        raise NotImplementedError
      end

      def to_s
        raise NotImplementedError
      end
    end
  end
end
