require_relative "line"

module EnvFileSyrup
  module Lines
    class CommentLine < Line
      def initialize(comment)
        @comment = comment.strip
      end

      def to_s
        @comment
      end
    end
  end
end
