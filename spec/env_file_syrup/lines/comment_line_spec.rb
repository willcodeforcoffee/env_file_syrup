require_relative "lines_helper"

RSpec.describe EnvFileSyrup::Lines::CommentLine do
  it_behaves_like "a line", described_class.new("comment")
end
