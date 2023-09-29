require_relative "lines_helper"

RSpec.describe EnvFileSyrup::Lines::BlankLine do
  it_behaves_like "a line", described_class.new
end
