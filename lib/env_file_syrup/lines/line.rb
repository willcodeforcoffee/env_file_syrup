module EnvFileSyrup
  module Lines
    class Line
      def clone
        raise NotImplementedError
      end

      def key_value?
        respond_to?(:key) && respond_to?(:value)
      end

      def to_s
        raise NotImplementedError
      end
    end
  end
end
